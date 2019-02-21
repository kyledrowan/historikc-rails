# frozen_string_literal: true

class Photo < ApplicationRecord
  belongs_to :location

  def summary
    "#{name} (#{date.zero? ? 'date unknown' : date})"
  end

  def caption
    "#{summary} - #{description}"
  end
end
