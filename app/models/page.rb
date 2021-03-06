class Page < ActiveRecord::Base
  validates_uniqueness_of :title
  validates_presence_of :title
  belongs_to :author, class_name: 'User'

  # @param [Sting|Integer] indentifier, a slug or a numeric or hashed id
  scope :find_by_slug_or_id, lambda { |identifier|
    pages = self.arel_table
    Page.find_by( pages[:id].eq(identifier).or(pages[:slug].eq(identifier)) )
  }

  acts_as_url :title,
              url_attribute: :slug,
              scope: :slug,
              blacklist: %w{ new, edit, users, photosets },
              blacklist_policy: lambda { |sc| "page-#{sc}" }

  before_save :parse_content, if: ->{ self.content_changed? },unless: -> { self.content.nil? || self.content.empty? }

  # @return [String]
  def to_param
    slug || id
  end

  private
  def parse_content
    require 'kramdown'
    self.compiled =  Kramdown::Document.new(content).to_html
  end
end