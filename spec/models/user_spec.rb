require 'rails_helper'
require 'support/omniauth'

RSpec.describe User, type: :model do
  it { should validate_uniqueness_of :email }
  it { should validate_uniqueness_of :flickr_uid }
  it { should validate_uniqueness_of :nickname }
  it { should have_many :authentications }

  describe '.new_from_omniauth' do
    subject { User.new_from_omniauth(mock_auth_hash) }
    it { should be_an_new_record }
    its(:email) { should eq 'joe@bloggs.com' }
    its(:flickr_uid) { should eq '1234567' }
    its(:name) { should eq 'Joe Bloggs' }
    its(:nickname) { should eq 'jbloggs' }
  end
end