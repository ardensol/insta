class Request < ActiveRecord::Base
	has_many :influencers
	belongs_to :user
	validates :search_term, presence: true, length: {minimum: 2}
	validates_format_of :search_term, with: /\A[a-zA-Z0-9-_]+\z/
end
