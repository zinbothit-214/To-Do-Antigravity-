class CommentsController < ApplicationController
  before_action :set_task

  def create
    authorize_task!
    @comment = @task.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @task, notice: 'Comment added.' }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @task, alert: 'Comment cannot be blank.' }
        format.js
      end
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
