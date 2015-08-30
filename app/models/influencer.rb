class Influencer < ActiveRecord::Base
	belongs_to :request
	validates :request, presence: true
end
