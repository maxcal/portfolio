require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  subject { response }

  describe 'DELETE #destroy' do
    before do |example|
      allow(controller).to receive(:sign_out!).and_return(true)
      delete :destroy unless example.metadata[:skip_request]
    end
    it { should redirect_to :root }
    it 'signs out user', skip_request: true do
      expect(controller).to receive(:sign_out!)
      delete :destroy
    end
  end

  describe 'GET new' do
    before do |example|
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