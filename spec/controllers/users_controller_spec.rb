require 'rails_helper'
require 'support/shared_examples/controllers'

RSpec.describe UsersController, type: :controller do

  let(:user) { create(:user) }
  let(:valid_session) { set_current_user(user) }
  let(:warden) { double(:warden) }

  before do |example|
    set_current_user(example.metadata[:valid_session] ? user : nil)
  end
  subject { response }

  RSpec.shared_examples "a singular resource representation" do
    it "should assign user as @user" do
      expect(assigns(:user).id).to eq user.id
    end
  end

  describe "GET #show" do
    before { get :show, id: user }
    it { should have_http_status :success }
    it { should render_template :show }
    it_should_behave_like "a singular resource representation"
  end

  describe "GET #edit" do
    let(:action) { get :edit, id: user }
    it_should_behave_like "an authorized action"
    context "when authorized", valid_session: true do
      before { get :edit, id: user }
      it { should have_http_status :success }
      it { should render_template :edit }
      it_should_behave_like "a singular resource representation"
    end
  end

  describe "PATCH #update" do

    let(:action) { patch :update, id: user, user: { name: 'New Name' } }

    it_should_behave_like "an authorized action"
    context "when authorized", valid_session: true do
      before { action }
      it_should_behave_like "a singular resource representation"
      it { should redirect_to user_path(user) }
      it "should update user" do
        user.reload
        expect(user.name).to eq 'New Name'
      end
      it 'flashes a message' do
        expect(controller.flash[:notice]).to eq I18n.t('users.flash.update.success')
      end
    end
    context 'when update fails', valid_session: true do
      before do
        allow_any_instance_of(User).to receive(:update).and_return(false)
        action
      end
      it { should render_template :edit }
      it 'flashes a message' do
        expect(controller.flash[:notice]).to eq I18n.t('users.flash.update.failure')
      end
    end

  end

  describe "GET #index" do
    context "when authorized", valid_session: true do
      before do
        valid_session
        get :index
      end
      it { should have_http_status :success }
      it { should render_template :index }
      it "should assign users as @users" do
        expect(assigns(:users).first).to be_a User
      end
    end
  end

  describe 'DELETE #destroy' do
    before { allow(controller).to receive(:sign_out!).and_return(false) }

    let(:action) { delete :destroy, id: user }

    it_should_behave_like "an authorized action"

    context "when authorized", valid_session: true do
      before { |e| action unless e.metadata[:skip_request] }
      it "deletes user" do
        expect(assigns(:user).destroyed?).to be_truthy
      end
      it 'flashes a message' do
        expect(controller.flash[:notice]).to eq I18n.t('users.flash.destroy.success_self')
      end
      it { should redirect_to :root }
    end
  end
end
