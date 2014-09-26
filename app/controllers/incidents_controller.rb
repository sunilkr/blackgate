class IncidentsController < ApplicationController

  def new
    @incident = Incident.new
  end

  def create
    params[:incident][:reportedOn] = Date.strptime(params[:incident][:reportedOn], "%Y-%m-%d")
    @incident = Incident.create(incident_params)
    respond_to do|format|
      if @incident.save
        format.html {render "show"}
        format.js {render js: @incident}
      else
        format.html { @incident.error.full_messages.each {|msg| flash[:error] = msg}}
        format.html { render js: @incident.error.full_messages}
      end
    end
  end

  def show 
    @incident = Incident.find(params[:id])
    #@samples = @incident.samples
  end

  def update
    @incident = Incident.update(params[:id], incident_params)
    respond_to do|format|
      format.html {render "show"}
      format.js {render js: @incident}
    end
  end

  def index
    @incidents = Incident.all
  end
  
  def edit
    @incident = Incident.find(params[:id])
  end

  def destroy
    @incident = Incident.find(params[:id])
    @incident.destroy
    respond_to do|format|
      format.html {redirect_to action: 'index'}
      format.js {render js: {action: "destroy", status: "complete", data: @incident}}
    end
  end

  protected
  def incident_params
    params.require(:incident).permit(:title, 
                                     :description, 
                                     :reportedOn, 
                                     :reportedBy, 
                                     :status)
  end

end
