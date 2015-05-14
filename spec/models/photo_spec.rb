require 'rails_helper'

RSpec.describe Photo, type: :model do
  it { should have_and_belong_to_many :photosets }
  it { should validate_uniqueness_of :flickr_uid }
end