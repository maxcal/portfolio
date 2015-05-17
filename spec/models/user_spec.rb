require 'rails_helper'
require 'support/omniauth'

RSpec.describe User, type: :model do
  it { should validate_uniqueness_of :email }
  it { should validate_uniqueness_of :flickr_uid }
  it { should validate_uniqueness_of :nickname }
  it { should have_many :authentications }
end