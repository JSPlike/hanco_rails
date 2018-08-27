class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @project = User.projects
  end
  
  def show
    project_find
  end
  
  def new
    @project = Project.new
  end
  
  def myproject
    # 나의 프로젝트 리스트를 불러들여야함
    @projects = current_user.projects
  end
  
  def invite # 함께할 파트너 초대
    receive = params[:email]
    
  end

  def exit # 글쓴이가 아닌 사람이 게시글을 나갈시
    participant = Participant.where('post_id = ? AND project_id = ?', parasm[:id], current_user.id)
    participant.destroy


    redirect_to '/'
  end

  def destroy # 프로젝트 만든사람이 글을 삭제
    project_find
    # 참여자 모두 삭제
    @project.participants.each do |p|
      p.destroy
    end
    @project.destroy
  end

  def edit
    project_find
  end

  def create
    project = Project.create(project_params)
    project.user_id = current_user.id
    project.save

    # 게시글을 만들었으면 참여자 정보를 갱신한다.
    Participant.create(
      user_id: current_user.id,
      project_id: project.id
    )
    redirect_to projects_myproject_url(project.id)
  end
  
  private
    def project_params
      params.require(:project).permit(:title, :project_kind);
    end
    def project_find # 해당 프로젝트 게시글을 찾아옴.
      @project = Project.find(params[:id])
    end
end
