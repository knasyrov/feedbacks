class CommentsController < ApplicationController
  def latest
		@comments = Comment.fetch_latest params[:id] 
		render json: @comments, each_serializer: CommentSerializer
  end

  def graph
  	comments = Comment.graph_data params[:id]
  	render json: comments.to_a, each_serializer: GraphDataSerializer
  end

end