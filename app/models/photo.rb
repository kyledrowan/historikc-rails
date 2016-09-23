class Photo < ActiveRecord::Base
	belongs_to :location

	def summary
		"#{name} (#{date == 0 ? 'date unknown' : date})"
	end

	def caption
		"#{summary} - #{description}"
	end
end
