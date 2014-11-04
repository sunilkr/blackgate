class SamplesController < ApplicationController
  before_action :set_sample, only: [:show, :edit, :update, :destroy, :download]

  # GET /samples
  # GET /samples.json
  def index
    @samples = Sample.all
  end

  # GET /samples/1
  # GET /samples/1.json
  def show
  end

  # GET incident/:id/samples/new
  def new
    @incident = Incident.find(params[:incident_id])
    @sample = Sample.new
  end

  # GET /samples/1/edit
  def edit
  end

  #TODO Fix flash messages
  # POST /samples
  # POST /samples.json
  def create
    logger.debug {"Processing create request"}
    @incident = Incident.find(params[:sample][:incident_id])
    if @incident == nil
      logger.error {"Incident #{params[:sample][:incident_id]} not found"}
      respond_to do|format|
        format.html {render "new", flash[:error] = "Incident cannot be found"}
        format.json {render js: {error: "Incident cannot be found"} }
      end
    end
    logger.debug {"Found Incident reported on #{@incident.reportedOn}"}

    sample_status = find_or_create()
    if sample_status == :failed_data
      respond_to do |format|
        format.html {redirect_to new_incident_sample_path(@incident), flash[:error] = "Failed to upload file."}
        format.json {render js: {status: :unprocessable_entity, sample: @sample}}
      end
    elsif sample_status == :failed_sample
      respond_to do|format|
        format.html {redirect_to new_incidnet_smaple_path(@incident), flash[:error] = "Failed to create Sample."}
        format.json {render js: {status: :unprocessable_entity, sample: @sample}}
      end
    end

    if [:found, :created].include?(sample_status)
      logger.debug { "Creating sample name..."}
      name = @sample.names.create(name: @fileName, 
                                reportedOn: @incident.reportedOn, 
                                incident: @incident
                               )
      if name.errors.any?
        flash[:warn] = "This sample is already uploaded"
        logger.debug {"Sample name exists"}
        name = @sample.names.where(incident: @incidnet, limit: 1)
      else 
        logger.debug {"Sample name created. #{name.inspect}"}
        if sample_status == :found
          flash[:info] = "Sample already exists. New name added."
        else
          flash[:info] = "Sample uploaded successfully."
        end
      end
    end
    respond_to do|format|
      format.html {redirect_to new_incident_sample_path(@incident)}
      format.json {render js: {status: sample_status, sample:@sample}}
    end
  end

  # PATCH/PUT /samples/1
  # PATCH/PUT /samples/1.json
  def update
    params[:sample][:categories].reject!(&:empty?)
    respond_to do |format|
      if @sample.update(sample_params)
        format.html { redirect_to @sample, notice: 'Sample was successfully updated.' }
        format.json { render :show, status: :ok, location: @sample }
      else
        format.html { render :edit }
        format.json { render json: @sample.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /samples/1
  # DELETE /samples/1.json
  def destroy
    @sample.destroy
    respond_to do |format|
      format.html { redirect_to samples_url, notice: 'Sample was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def download
    name = params[:name] || @sample.names.first.name
    send_data @sample.data.decrypted_content,
      filename: name,
      type: @sample.data.mimeType
    logger.debug {"Sent decrypted file: #{@sample.data.file}"}
  end

  # GET samples/1/subsamples
  def sub_samples
    #render "sub_samples"
  end

  # POST samples/1/subsamples
  def create_sub_samples
    
  end

  def show_cnc_traffic
    @traffics = @sample.cnc_traffics.find(params[:cnc_traffic])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sample
      @sample = Sample.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sample_params
      params.require(:sample).permit(:group, :comment, :reportedOn,
                                     :status, :analyzedOn,
                                     categories: [])

    end

    def find_or_create
      #TODO: Wish there was a better way.....
      upload = params[:sample][:file]
      content = upload.read
      mime = upload.content_type
      sha1 = Digest::SHA1.hexdigest(content)
      @fileName = upload.original_filename
      logger.debug {"Upload file name: #{@fileName}"}

      logger.debug {"Searching sample data for SHA1: #{sha1} ..."}
      data = SampleData.find_by(sha1: sha1)
      #TODO: Long if-else. Refactor
      if data
        logger.warn {"Found existing sample data: #{data.id}"}
        @sample = data.sample
        return :found
      else
        logger.debug {"Creating new Sample Data..."}
        data = SampleData.new(data: content, mimeType: mime)
        if data.save
          logger.info {"New data uploaded: #{@data.inspect}"}
          logger.debug {"Creating new Sample..."}

          @sample = Sample.create(status: "New",
                                  reportedOn: @incident.reportedOn)
          if @sample.errors.any?
            logger.error {"Failed to create sample."}
            logger.error {@sample.errors.inspect}
            data.destroy
            return :failed_sample
          else
            @sample.data = data
            logger.info {"Sample created #{@sample.inspect}"}
            return :created
          end
        else
          logger.error {"Failed to create sample data"}
          logger.error {data.inspect}
          return :failed_data
        end
      end
    end 
end
