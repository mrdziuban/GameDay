class TopicsController < ApplicationController
  before_filter :authenticate_user!

  def create
    params[:topic][:description] = ReverseMarkdown.parse(params[:topic][:description])
    @topic = Topic.new(params[:topic])
    @topic.user_id = current_user.id
    @topic.forum_id = params[:forum_id]
    if @topic.save
      redirect_to forum_topic_url(@topic.forum, @topic)
    else
      redirect_to forum_url(@topic.forum, topic: "invalid")
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @comments = @topic.comments_by_parent
    unless @comments == {}
      @top_level = Kaminari.paginate_array(@comments[nil]).page(params[:page]).per(100)
    end
    if request.xhr?
      render partial: "comments", locals: {comments: @comments, top_level: @top_level}
    end
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.user != current_user
      render nothing: true
    else
      @topic.update_attributes(params[:topic])
      if request.xhr?
        render partial: "topic", locals: {topic: @topic}
      end
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    if @topic.user != current_user
      render nothing: true
    else
      @topic.destroy
      redirect_to forum_url(@topic.forum)
    end
  end
end