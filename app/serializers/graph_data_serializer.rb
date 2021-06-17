class GraphDataSerializer < ActiveModel::Serializer
  attributes :created_date, :count

  def created_date
  	puts object.inspect
  	object[:date]
  end

  def count
  	object[:cnt]
  end
end
