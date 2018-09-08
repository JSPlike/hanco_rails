class ProjectsController < ApplicationController
  before_action :authenticate_user!

  def index
  end
  def show
    project_find
  end

  def myproject
    temp = Project.last #임의 값
    @participants = Participant.where('user_id = ?', current_user.id)
    # 아직 용도를 모르겠음.
    # @projects = current_user.projects
  end
  
  def invite # 함께할 파트너 초대 (파라미터 상대메일주소, 게시글번호 필요)
    invite_user = User.where('email = ?',params[:email])[0]
    invite_key = ""
    rd = Random.new

    if !invite_user # 없는 유저라면 메시지 추가필요
      message_herf('회원가입이 필요합니다.', '/') and return
    end



    # 현재 지메일로 가입한 유저는 찾을 수 없음
    invite_user.participants.each do |p|
      if p.project_id == params[:id].to_i
        message_herf('이미 등록된 유저입니다.', '/') and return
      end
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
    
    # 기존에 초대명단이 있으면 가장 마지막 메일이 유효하다. 메시지 필요
    invites = Invite.where('user_id = ? AND project_id = ?', invite_user.id, params[:id].to_i)
    invites.each do |i|
      i.destroy
    end

    Invite.create(
      temp_key: invite_key,
      user_id: invite_user.id,
      
      project_id: params[:id].to_i
    )

    WebmailMailer.invite_email_send(current_user.email,invite_user.email, Invite.last).deliver_now
    # 메일보내고 redirect
    message_herf('초대완료', show_project_url(params[:id])) and return

  end

  def join # 메일로 초대메일을 받았을때
    invite_data = Invite.where('user_id = ? AND project_id = ? AND temp_key = ?', params[:user_id].to_i, params[:project_id].to_i, params[:key])[0]
    if invite_data
      Participant.create(
        project_id: params[:project_id].to_i,
        user_id: current_user.id     
      )
      invite_data.destroy 
    else
      message_herf('잘못된 접근입니다.', '/') and return
    end
    message_herf('참여완료', show_project_url(params[:project_id])) and return
  end

  def exit # 글쓴이가 아닌 사람이 게시글을 나갈시
    participant = Participant.where('project_id = ? AND user_id = ?', parasm[:id].to_i, current_user.id)
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
      params.permit(:title, :project_kind, :desc)
    end
    def project_find # 해당 프로젝트 게시글을 찾아옴.
      @project = Project.find(params[:id].to_i)
    end
    def message_herf(message, link)
      render html: "<script>alert('#{message}'); location.href='#{link}';</script>".html_safe
    end
end
