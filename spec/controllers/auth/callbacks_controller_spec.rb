require 'rails_helper'
require 'support/omniauth'

RSpec.describe Auth::CallbacksController, type: :controller do

  subject { response }

  let(:warden){ double('warden') }

  before do
    request.env['omniauth.auth'] = mock_flickr_authentication(mock_auth_hash)
    allow(warden).to receive(:set_user)
    request.env['warden'] = warden
  end

  describe "GET #flickr" do
    it "redirect to root path" do
      get :flickr
      expect(response).to redirect_to :root
    end
    it "signs in the user" do
      expect(warden).to receive(:set_user).with(an_instance_of(User))
      get :flickr
    end
    it "makes the user an admin if it is the first user" do
      get :flickr
      expect(assigns(:user).has_role?(:admin)).to be_truthy
    end
  end

  describe "GET #failure" do
    before { |example| get :failure unless example.metadata[:skip_request] }
    it { should redirect_to root_path }
  end
end
