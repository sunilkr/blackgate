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

    #TODO: Wish there was a better way.....
    upload = params[:sample][:file]
    content = upload.read
    mime = upload.content_type
    sha1 = Digest::SHA1.hexdigest(content)
    fileName = upload.original_filename
    logger.debug {"Upload file name: #{fileName}"}

    logger.debug {"Finding sample data for SHA1: #{sha1} ..."}
    data = SampleData.find_by(sha1: sha1)
    #TODO: Long if-else. Refactor
    if data
      logger.warn {"Found existing sample data: #{data.id}"}
      @sample = data.sample
      flash[:warn] = "This file already exists"
    else
      logger.debug {"Creating new sample ..."}
      @sample = Sample.create(status: "New", 
                              reportedOn: @incident.reportedOn)
      if @sample.errors.any?
        logger.error {"Failed to create sample due to following erros"}
        logger.error {@sample.errors.inspect}
      else
        logger.debug {"Sample created: #{@sample.inspect}"}
        flash[:info] = "Sample created successfully"
        logger.debug {"Creating sample data..."}
        new_data = @sample.create_data(data: content, mimeType: mime)
        if new_data.errors.any?
          logger.error {"Failed to create sample's data due to following errors..."}
          logger.error {new_data.errors.inspect}
        else
          logger.debug {"Sample data created: #{new_data.inspect}"}
          flash[:info] = "Data created successfully"
        end
      end
    end

    logger.debug { "Creating sample name..."}
    name = @sample.names.create(name: fileName, 
                                reportedOn: @incident.reportedOn, 
                                incident: @incident
                               )
    if name.errors.any?
      flash[:warn] = "This sample is already uploaded"
      logger.debug {"Sample name exists"}
      name = @sample.names.where(incident: @incidnet, limit: 1)
    else 
      logger.debug {"Sample name created. #{name.inspect}"}
    end

    respond_to do|format|
      format.html {redirect_to new_incident_sample_path(@incident)}
      format.json {render js: name}
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
end
