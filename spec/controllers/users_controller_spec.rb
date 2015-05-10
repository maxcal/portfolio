require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  let(:user) { create(:user) }
  before { set_current_user(nil) }
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
    context "when unauthorized" do
      it "denies access" do
        expect {
          get :edit, id: user
        }.to raise_error(CanCan::AccessDenied)
      end
    end

    context "when authorized" do
      before do
        set_current_user(user)
        get :edit, id: user
      end
      it { should have_http_status :success }
      it { should render_template :edit }

      it "should assign user as @user" do
        expect(assigns(:user)).to be_a User
      end
    end
  end

  describe "GET #index" do
    context "when authorized" do
      before do
        set_current_user(user)
        get :index
      end
      it { should have_http_status :success }
      it { should render_template :index }

      it "should assign users as @users" do
        expect(assigns(:users).first).to be_a User
      end
    end
  end

  describe "PATCH #update" do

    context "when unauthorized" do
      it "denies access" do
        expect {
          patch :update, id: user
        }.to raise_error(CanCan::AccessDenied)
      end
    end

    context "when authorized" do
      before do
        set_current_user(user)
        patch :update, id: user, user: { name: 'New Name' }
      end
      it { should redirect_to user }

      it "should update user" do
        user.reload
        expect(user.name).to eq 'New Name'
      end
    end
  end
end
