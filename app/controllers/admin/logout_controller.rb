# frozen_string_literal: true

module Admin
  class LogoutController < ApplicationController
    def logout
      reset_session
      redirect_to '/'
    end
  end
end
