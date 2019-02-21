# frozen_string_literal: true

module Admin
  class PhotosController < Admin::ApplicationController
    # rubocop:disable Metrics/AbcSize
    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::Search.new(resource_resolver, search_term).run

      case params[:location_mapped]
      when 'true'
        resources = resources.where.not(location_id: nil)
      when 'false'
        resources = resources.where(location_id: nil)
      end

      case params[:active]
      when 'true'
        resources = resources.where(active: true)
      when 'false'
        resources = resources.where(active: false)
      end

      resources = order.apply(resources)
      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page
      }
    end
    # rubocop:enable Metrics/AbcSize
  end
end
