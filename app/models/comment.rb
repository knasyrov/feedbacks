require 'httparty'

class Comment < ApplicationRecord

	scope :by_imt_id, ->(imt_id) { where(imt_id: imt_id) }
	scope :todays, -> { where("created_date > #{Date.today.to_s(:db)}") }

	def self.fetch_latest imt_id
		api_url = 'https://public-feedbacks.wildberries.ru/api/v1/feedbacks'

		response = HTTParty.post('https://public-feedbacks.wildberries.ru/api/v1/feedbacks', { body:
			{
				skip: 0,
			  imtId: imt_id.to_i,
			  order: 'dateDesc',
			  take: 10
			 }.to_json
		})
		result = []

		if response.code.eql?(200)
			
			response.parsed_response['feedbacks'].each do |f|
				comment = Comment.find_or_initialize_by(source_id: f['id'])
				if comment.new_record?
					comment.body = f['text']
					comment.imt_id = f['imtId']
					comment.created_date = DateTime.parse(f['createdDate'])
					comment.save rescue ActiveRecord::StatementInvalid
				end
				result.push comment
			end
		
		end

		result
	end

	def self.graph_data imt_id
		select('COUNT(source_id) cnt, DATE(created_date) date').group('DATE(created_date)').by_imt_id(imt_id).where("created_date > #{(Date.today - 30.days).to_s(:db)}")
	end
end
