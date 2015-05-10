require 'rails_helper'

RSpec.describe SessionsHelper do

  # Stub warden
  let(:warden) { double('warden') }
  before { helper.request.env['warden'] = warden }

  describe '.current_user' do
    it "gets the current user from warden" do
      expect(warden).to receive(:user)
      helper.current_user
    end
  end

  describe '.signed_in?' do
    it "checks if there is a signed in user" do
      allow(warden).to receive(:user) { true }
      expect(helper.signed_in?).to be_truthy
    end
  end
end