class RepliesController < ApplicationController
  before_action :set_topic, only: [:new, :create]
  before_action :set_reply, only: [:show, :edit, :update, :destroy]

  # GET /replies or /replies.json
  def index
    @replies = Reply.all
  end

  # GET /replies/1 or /replies/1.json
  def show
  end

  # GET /replies/new
  def new
    @reply = @topic.replies.build
  end

  # GET /replies/1/edit
  def edit
  end

  # POST /replies or /replies.json
  def create
    @reply = @topic.replies.build(reply_params)

    if @reply.save
      redirect_to @topic, notice: 'Reply was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /replies/1 or /replies/1.json
  def update
    if @reply.update(reply_params)
      redirect_to @reply.topic, notice: 'Reply was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /replies/1 or /replies/1.json
  def destroy
    topic = @reply.topic
    @reply.destroy
    redirect_to topic_path(topic), notice: 'Reply was successfully deleted.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reply
      @reply = Reply.find(params[:id])
    end

    def set_topic
      @topic = Topic.find(params[:topic_id])
    end

    # Only allow a list of trusted parameters through.
    def reply_params
      params.require(:reply).permit(:content, :author_name)
    end
end
