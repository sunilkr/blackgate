class CncTrafficsController < ApplicationController
  before_action :set_sample
  before_action :set_cnc, only: [:index, :show]
  
  def index
    if @sample
      @traffics = @sample.cnc_traffics(true)
    elsif @cnc
      @traffics = @cnc.cnc_traffics(true)
    else
      @traffics = CncTraffic.all
    end
  end

  def new
    @traffic = @sample.cnc_traffics.build
    @cnc = CommandAndControl.new
  end

  def show
    @traffic = CncTraffic.find(params[:id])
  end

  def edit
  end

  def update
  end

  def create
    cnc_status = find_or_create_cnc
    respond_to do|format|
      if cnc_status == :failed
        format.html {redirect_to @sample, flash['error'] = "Failed to find/create C&C."}
        fromat.json {render json: @cnc, status: :unproccessable_entity}
      else
        if @sample
          @traffic = @sample.cnc_traffics.create(traffic_params)
          update_cnc
          format.html { redirect_to sample_path(@sample),
                        notice: "Traffic linked to"+
                                "#{'(NEW)' if cnc_status == :created} C&C."
                      }
          format.json { render json: {sample: @sample, cnc: @cnc}, status: cnc_status}
        end
      end
    end
  end

  protected
  def set_sample
    @sample = (Sample.find(params[:sample_id]) if params.include? :sample_id) || nil
  end

  def set_cnc
    @cnc = (CommandAndControl.find(params[:command_and_control_id]) if params.include? :command_and_control_id) || nil
  end

  def find_or_create_cnc(params=cnc_params)
    @cnc = CommandAndControl.where("ip=? AND domain=? AND port=?",
                                   params[:ip], params[:domain], params[:port]).
                                   limit(1)[0]
    if @cnc
      return :found
    else
      @cnc = CommandAndControl.new(cnc_params)
      if @cnc.save
        return :created
      else
        return :failed
      end
    end
  end

  def update_cnc
    if @cnc
      @cnc.cnc_traffics<< @traffic
      # update if either nil or later than traffic date
      first_access = (@cnc.first_access && (@cnc.first_access < @traffic.accessedOn))? @cnc.first_access : @traffic.accessedOn
      # update if either nil or earlier than traffic date
      last_access = (@cnc.last_access && (@cnc.last_access > @traffic.accessedOn))? @cnc.last_access : @traffic.accessedOn
      @cnc.update(first_access: first_access, last_access: last_access)
    end
  end

  def cnc_params
    params.require(:command_and_control).
            permit(:domain, :ip, :port, :protocol, :first_access, :last_access)
  end

  def traffic_params
    params.require(:cnc_traffic).permit(:url, :status, :accessedOn, :request, :response)
  end
end
