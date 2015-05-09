require 'rails_helper'
require 'support/omniauth'

RSpec.describe Authentication do
  it { should validate_uniqueness_of :uid }

  describe '.new_from_omniauth' do
    subject { Authentication.new_from_omniauth(mock_auth_hash) }
    its(:uid) { should eq '1234567' }
    its(:provider) { should eq "flickr" }
    its(:expires_at) { should eq Time.at(1321747205) }
  end

  describe '.update_from_omniauth!' do
    let(:auth) { Authentication.new(user: create(:user)) }
    before { auth.update_from_omniauth!(mock_auth_hash) }
    subject { auth }
    its(:expires_at) { should eq Time.at(1321747205) }
    its(:token) { should eq 'ABCDEF...' }
  end
end