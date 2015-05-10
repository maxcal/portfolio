require 'rails_helper'
require 'support/omniauth'

RSpec.describe Authentication do
  it { should validate_uniqueness_of :uid }
  it { should belong_to :user }

  describe '.create_from_omniauth' do
    subject { Authentication.create_from_omniauth(mock_auth_hash) }
    its(:uid) { should eq '1234567' }
    its(:provider) { should eq "flickr" }
  end

  describe '.update_from_omniauth!' do
    let(:auth) { Authentication.new(user: create(:user)) }
    before { auth.update_from_omniauth!(mock_auth_hash) }
    subject { auth }
    its(:token) { should eq 'ABCDEF...' }
  end
end