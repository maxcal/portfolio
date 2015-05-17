require 'rails_helper'
require 'support/omniauth'

RSpec.describe AuthServices::Authenticate do

  let(:auth_hash){ mock_auth_hash }
  let(:service){ described_class.new }

  describe '#call' do
    context 'when new' do
      let(:auth) { Authentication.last }
      it 'creates a new authentication' do
        service.call(auth_hash)
        expect(auth.uid).to eq '1234567'
        expect(auth.provider).to eq 'flickr'
      end
    end
    context 'if an an authorization already exists' do
      let!(:auth) { create(:authentication, uid: auth_hash[:uid], provider: auth_hash[:provider]) }
      it 'does not create a new authentication' do
        expect {
          service.call(auth_hash)
        }.to_not change(Authentication, :count)
      end
      context 'if authentication does not yet have a user' do
        it 'creates a new user' do
          user = service.call(auth_hash)
          expect(user.flickr_uid).to eq '1234567'
          expect(user.email).to eq 'joe@bloggs.com'
          expect(user.name).to eq 'Joe Bloggs'
          expect(user.nickname).to eq 'jbloggs'
          expect(user.persisted?).to be_truthy
        end
      end
      context 'if user exists' do
        before { auth.update(user: create(:user)) }
        it 'does not create a new user' do
          expect {
            service.call(auth_hash)
          }.to_not change(User, :count)
        end
      end
    end
  end
end