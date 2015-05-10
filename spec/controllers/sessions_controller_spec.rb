require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  subject { response }
  let(:warden) { double('warden') }
  before { request.env['warden'] = warden }

  describe 'DELETE #destroy' do
    before do |example|
      allow(warden).to receive(:logout)
      delete :destroy unless example.metadata[:skip_request]
    end
    it { should redirect_to :root }
    it 'signs out user', skip_request: true do
      expect(warden).to receive(:logout)
      delete :destroy
    end
  end

  describe 'GET new' do
    before do |example|
      allow(warden).to receive(:user)
      allow(controller).to receive(:signed_in?).and_return(example.metadata[:signed_in] || false)
      get :new
    end
    context 'without a signed in user' do
      it { should render_template :new }
    end
    context 'with a signed in user', signed_in: true do
      it { should redirect_to :root }
    end
  end
end