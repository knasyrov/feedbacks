class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_date
end
