class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  ##devise gem 문서참조 로그인이 아닐시 해당 페이지 참조 불가 index는 제외하라
  before_action :authenticate_user!, execept: [:index]
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    authorize_action_for @post
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html { redirect_to '/posts', notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update

    authorize_action_for @post
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update(user_id: @post.user_id, content: params[:post][:content], image: params[:post][:image])
        # 내가 수정한 내용
        logger.debug format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        logger.debug format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    authorize_action_for @post
    @post = Post.find(params[:id])

    @post.destroy
    respond_to do |format|
      format.html { redirect_to '/posts', notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:content, :image)
    end
end
