class ProjectsController < ApplicationController
  
  def index
    @project = Project.all
  end
  
  def show
    
  end
  
  def new
    @project = Project.new
  end
  
  def myproject
    
  end
  
  def create
    
  end
  
  private
    def project_params
      params.require(:project).permit(:content, :project_kind);
    end
  
end
