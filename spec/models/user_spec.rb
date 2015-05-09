require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_uniqueness_of :email, case_sensitive: false }
  it { should validate_uniqueness_of :flickr_uid }
  it { should validate_uniqueness_of :nickname }
end
