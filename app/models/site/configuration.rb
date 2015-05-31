class Site::Configuration < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :site_title
  enum status: [:disabled, :active]
  after_save :deactivate_other_configs!, if: :active?

  private
  def deactivate_other_configs!
    self.class.where.not(id: id).update_all(status: :disabled)
  end
end