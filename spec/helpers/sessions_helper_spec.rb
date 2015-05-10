require 'rails_helper'

RSpec.describe SessionsHelper do

  let(:warden) { double('warden') }
  let(:user){ build_stubbed(:user) }

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

  describe '.sign_out!' do
    it "signs the user out" do
      expect(warden).to receive(:logout)
      helper.sign_out!
    end
  end

  describe '.sign_in' do
    it "signs the users in" do
      expect(warden).to receive(:set_user).with(user)
      helper.sign_in(user)
    end
  end
end