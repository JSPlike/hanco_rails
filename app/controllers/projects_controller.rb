class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
    @project = current_user.projects
  end
  
  def show
    project_find
  end
  
  def new
    @project = Project.new
  end
  
  def myproject
    # 아직 용도를 모르겠음.
    # @projects = current_user.projects
  end
  
  def invite # 함께할 파트너 초대 (파라미터 상대메일주소, 게시글번호 필요)
    
    invite_user = User.where('email = ?',params[:email])
    invite_user = invite_user[0]
    invite_key = ""
    rd = Random.new

    if !invite_user # 없는 유저라면 메시지 추가필요
      redirect_to '/' and return
    end
    
    # 20개의 임의의 인증키를 만듬
    while invite_key.length != 20
      temp = rd.rand(48..122)
      if (temp >= 48 && temp <=57) || (temp >=65 && temp<=90) || (temp>=97 && temp <=122)
        invite_key+= temp.chr
      else
        next
      end
    end
    
    # 기존에 초대명단이 있으면 가장 마지막 메일이 유효하다. alert 필요
    invites = Invite.where('user_id = ? AND project_id = ?', invite_user.id, params[:id])
    invites.each do |i|
      i.destroy
    end

    Invite.create(
      temp_key: invite_key,
      user_id: invite_user.id,
      project_id: params[:id]
    )

    WebmailMailer.invite_email_send(current_user.email,invite_user.email, Invite.last).deliver_now
    # 메일보내고 redirect
    redirect_to '/'

  end

  def join # 메일로 초대메일을 받았을때
    if !params[:project_id] || !params[:key] || !params[:user_id]
      redirect_to '/' and return
    end 

    invite_data = Invite.where('user_id = ? AND project_id =?', params[:user_id].to_i, params[:project_id].to_i)[0]
  
    #연결된 유저가 링크에 파라미터와 같은지 확인하고, 초대키가 데이터베이스에 저장된 키와 같은지 검증한다.
    if (current_user.id == params[:user_id]) && (invite_data.temp_key == params[:key])
      Participant.create(
        project_id: params[:project_id],
        user_id: current_user.id     
      )
      invite_data.destroy 
    end
    redirect_to '/'
  end

  def exit # 글쓴이가 아닌 사람이 게시글을 나갈시
    participant = Participant.where('project_id = ? AND user_id = ?', parasm[:id], current_user.id)
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
    redirect_to show_project_url(project.id)
  end
  
  private
    def project_params
      params.require(:project).permit(:title, :project_kind);
    end
    def project_find # 해당 프로젝트 게시글을 찾아옴.
      @project = Project.find(params[:id])
    end
end
