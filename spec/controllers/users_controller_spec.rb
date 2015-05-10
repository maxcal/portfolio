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

  describe "GET #show" do
    before { get :show, id: user }
    it { should have_http_status :success }
    it { should render_template :show }
    it "should assign user as @user" do
      expect(assigns(:user)).to be_a User
    end
  end

  describe "GET #edit" do
    it_should_behave_like "an authorized action" do
      let(:action) { get :edit, id: user }
    end
    context "when authorized", valid_session: true do
      before { get :edit, id: user }
      it { should have_http_status :success }
      it { should render_template :edit }
      it "assigns user as @user" do
        expect(assigns(:user)).to be_a User
      end
    end
  end

  describe "PATCH #update" do
    it_should_behave_like "an authorized action" do
      let(:action) { get :edit, id: user }
    end
    context "when authorized", valid_session: true do
      before { patch :update, id: user, user: { name: 'New Name' } }
      it { should redirect_to user_path(user) }
      it "should update user" do
        user.reload
        expect(user.name).to eq 'New Name'
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

    before do |example|
      allow(controller).to receive(:current_user).and_return(example.metadata[:valid_session] ? user : nil)
      allow(controller).to receive(:sign_out!).and_return(false)
    end

    it_should_behave_like "an authorized action" do
      let(:action) { delete :destroy, id: user }
    end

    context "when authorized", valid_session: true do
      it "deletes user" do
        expect {
          delete :destroy, id: user
        }.to change(User, :count).by(-1)
      end
    end
  end
end
