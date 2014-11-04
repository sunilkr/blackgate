class CommandAndControlsController < ApplicationController
  before_action :set_command_and_control, only: [:show, :edit, :update, :destroy]

  # GET /command_and_controls
  # GET /command_and_controls.json
  def index
    @cncs = CommandAndControl.all
  end

  # GET /command_and_controls/1
  # GET /command_and_controls/1.json
  def show
  end

  # GET /command_and_controls/new
  def new
    @sample = Sample.find(params[:sample_id]) if params[:sample_id]
    @cnc = CommandAndControl.new
  end

  # GET /command_and_controls/1/edit
  def edit
  end

  # POST /cncs
  # POST /cncs.json
  # POST /samples/:sample_id/cncs
  # POST /sample/:sample_id/cncs.json
  def create
    cnc_status = find_or_create(cnc_params)
    respond_to do |format|
      if cnc_status == :failed
        format.html{ render ((@sample)? @sample : @cnc), 
                              flash['error'] = "Failed to find or create C&C"
                  }
        format.json{ render json: @cnc.errors, status: :unprocessable_entity}
      else
        @sample = (Sample.find(params[:sample_id]) if params[:sample_id]) || nil
        if @sample
          @traffic = @sample.cnc_traffics.create(traffic_params)
          @cnc.cnc_traffics<< @traffic
          @cnc.update(last_access: @traffic.accessedOn)
          format.html {redirect_to sample_path(@sample), 
                       notice: "Traffic linked to"+
                                        " #{'(NEW)' if cnc_status == :created} C&C."
                      }
          format.html {render json: {sample: @sample, cnc: @cnc}, status: cnc_status}
        else
          format.html {
            if cnc_status == :created
              flash[:notice] = "C&C Created Successfully"
            else
              flash[:warning] = "C&C Already Exists"
            end
            render @cnc
          }
          format.json {render json: @cnc, status: cnc_status}
        end
      end
    end
  end

  # PATCH/PUT /command_and_controls/1
  # PATCH/PUT /command_and_controls/1.json
  def update
    respond_to do |format|
      if @cnc.update(cnc_params)
        format.html { redirect_to @cnc, notice: 'Command and control was successfully updated.' }
        format.json { render :show, status: :ok, location: @cnc }
      else
        format.html { render :edit }
        format.json { render json: @cnc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /command_and_controls/1
  # DELETE /command_and_controls/1.json
  def destroy
    @cnc.destroy
    respond_to do |format|
      format.html { redirect_to cncs_url, notice: 'Command and control was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  protected
    # Use callbacks to share common setup or constraints between actions.
    def set_command_and_control
      @cnc = CommandAndControl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cnc_params
      cnc_traffic = params[:command_and_control][:cnc_traffic]
      if cnc_traffic
        params[:command_and_control][:first_access] = cnc_traffic[:accessedOn]
        params[:command_and_control][:last_access] = cnc_traffic[:accessedOn]
      end
      params.require(:command_and_control).permit(:domain, :ip, 
                                                  :protocol, :port,
                                                  :first_access,
                                                  :last_access)
    end

    def traffic_params
      params.require(:command_and_control).
              require(:cnc_traffic).permit(:url,:status, :accessedOn,
                                          :request, :response)
    end

    def find_or_create(params=cnc_params())
      @cnc = CommandAndControl.where("ip=? AND domain=? AND port=?",
                                      params[:ip],params[:domain],params[:port]).
                                      limit(1)[0]
      if @cnc
        return :found
      else
        @cnc = CommandAndControl.new(params)
        if @cnc.save
          return :created
        else
          return :failed
        end
      end
    end
end
