# frozen_string_literal: true

require 'administrate/base_dashboard'

class PhotoDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    location: Field::BelongsTo,
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    date: Field::String,
    tags: Field::String,
    image_url: PhotoField,
    thumbnail_url: PhotoField,
    width: Field::Number,
    height: Field::Number,
    address: Field::String,
    latitude: Field::String.with_options(searchable: false),
    longitude: Field::String.with_options(searchable: false),
    angle: Field::Number,
    active: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    name
    description
    location
    date
    active
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    location
    active
    id
    name
    description
    date
    tags
    image_url
    thumbnail_url
    width
    height
    address
    latitude
    longitude
    angle
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    location
    active
    name
    description
    date
    tags
    image_url
    thumbnail_url
    width
    height
    address
    latitude
    longitude
    angle
  ].freeze

  # Overwrite this method to customize how photos are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(photo)
    photo.name
  end
end
