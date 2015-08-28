class Request < ActiveRecord::Base
	has_many :influencers
	belongs_to :user
end
