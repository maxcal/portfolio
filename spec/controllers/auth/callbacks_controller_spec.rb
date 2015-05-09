require 'rails_helper'
require 'support/omniauth'

RSpec.describe Auth::CallbacksController, type: :controller do

  subject { response }

  let(:warden){ double('warden') }

  before do
    request.env['omniauth.auth'] = mock_flickr_authentication(mock_auth_hash)
    # Stub out warden.
    allow(warden).to receive(:set_user)
    request.env['warden'] = warden
  end

  describe "GET #flickr" do
    before { |example| get :flickr unless example.metadata[:skip_request] }
    it { should redirect_to root_path }
    it "creates user", skip_request: true do
      expect {
        get :flickr
      }.to change(User, :count).by(+1)
    end
    it "creates authentication", skip_request: true do
      expect {
        get :flickr
      }.to change(Authentication, :count).by(+1)
    end
    it "does not create a new user for each auth" do
      expect {
        get :flickr
      }.to_not change(User, :count)
    end
    it "signs in the user", skip_request: true do
      expect(warden).to receive(:set_user).with(assigns(:user))
      get :flickr
    end
  end
end