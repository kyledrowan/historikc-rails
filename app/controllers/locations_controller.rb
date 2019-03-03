# frozen_string_literal: true

class LocationsController < ApplicationController
  def index
    @locations = Photo.where(active: true).where.not(location_id: nil).to_a.map(&:location).uniq

    respond_to do |format|
      format.html { render :index, layout: ENV['ENABLE_VIEW'].present? ? 'application' : 'downtime' }
      format.json { render json: @locations }
    end
  end

  def show
    @location = Location.find(params[:id])

    respond_to do |format|
      format.html { render :show, layout: ENV['ENABLE_VIEW'].present? ? 'application' : 'downtime' }
      format.json { render json: @location.to_json(include: :photos) }
    end
  end
end
