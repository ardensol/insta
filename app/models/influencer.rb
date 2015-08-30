class Influencer < ActiveRecord::Base
	belongs_to :request
	has_many :users, through: :requests
	validates :request, presence: true
	validates :instagram_id, uniqueness: { scope: :request_id } 

	default_scope ->{ order('followers DESC') }
end
