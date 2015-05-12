require 'rails_helper'

RSpec.describe Photoset, type: :model do
  it { should validate_uniqueness_of :flickr_uid }
  it { should validate_uniqueness_of :title }
end
