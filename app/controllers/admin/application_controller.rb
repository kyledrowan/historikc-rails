# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_filters.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
  	before_filter :ensure_dev

  	def ensure_dev
  		raise StandardError unless Rails.env.development?
  	end

    def records_per_page
      params[:per_page] || 50
    end
  end
end
