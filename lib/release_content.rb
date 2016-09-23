module Content
	def self.release(model)
		timestamp = Time.now.strftime("%Y%m%d%H%M%S")
		file_format = "_release_#{model.classify.underscore}.rb"
		filename = "#{timestamp}#{file_format}"
		releases = Dir.glob(Rails.root.join("db/migrate/*#{file_format}")).sort
		last_release = releases.empty? ? Time.new(1850) : releases.last.slice(-filename.length, timestamp.length).to_time

		File.open(Rails.root.join("db/migrate/#{filename}"), 'w') do |file|
			file.puts "class Release#{model.classify} < ActiveRecord::Migration"
			file.puts "  def change"

			model.classify.constantize.where("created_at > ?", last_release).each do |item|
				file.write "    #{model.classify}.create!("
				item.attributes.each { |key, value| file.write "#{key}: '#{value.to_s.gsub("'", "\\\\'")}', " }
				file.write ") \n"
			end

			file.puts ''

			model.classify.constantize.where("created_at <= ? and updated_at > ?", last_release, last_release).each do |item|
				file.write "    #{model.classify}.find(#{item.id}).update!("
				item.attributes.except(:id).each { |key, value| file.write "#{key}: '#{value.to_s.gsub("'", "\\\\'")}', " }
				file.write ") \n"
			end

			file.puts "  end"
			file.puts "end"
		end

		ActiveRecord::Base.connection.execute("INSERT INTO schema_migrations (version) VALUES(#{timestamp})")
	end
end
