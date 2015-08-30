class Request < ActiveRecord::Base
	has_many :influencers
	belongs_to :user
	validates :search_term, presence: true, length: {minimum: 2}
end
