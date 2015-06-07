require 'rails_helper'
require 'support/shared_examples/controllers'

RSpec.describe PagesController, type: :controller do

  subject { response }
  let(:page) { create(:page) }
  let(:admin) { create(:admin) }

  before do |example|
    set_current_user(example.metadata[:authorized] ? admin : nil)
  end

  describe "GET #home" do
    before { get :home }
    it { should have_http_status(:success) }
    it { should render_template(:home) }
  end

  describe "GET #show" do
    let(:action) { get :show, id: page }
    context "when authorized", authorized: true do
      before { action }
      it { should have_http_status :success }
      it { should render_template :show }
      it "assigns the requested page as @page" do
        expect(assigns(:page)).to eq(page)
      end
    end
  end

  describe "GET #new" do
    let(:action) { get :new }
    it_should_behave_like 'an authorized action'

    context "when authorized", authorized: true do
      before { action}
      it { should render_template :new }
      it { should have_http_status :success }
      it "assigns a new page as @page" do
        expect(assigns(:page)).to be_a_new(Page)
      end
    end
  end

  describe "GET #edit" do
    let(:action) { get :edit, id: page }
    it_should_behave_like 'an authorized action'

    context "when authorized", authorized: true do
      before { action }
      it { should render_template :edit }
      it { should have_http_status :success }
      it "assigns the requested page as @page" do
        expect(assigns(:page)).to eq(page)
      end
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { attributes_for(:page) }
    let(:invalid_attributes) { { page: nil } }
    let(:action) { post :create, page: valid_attributes  }

    it_should_behave_like 'an authorized action'

    context "when authorized", authorized: true do
      before {|ex| action unless ex.metadata[:skip_request] }

      context "with valid params" do
        it "creates a new Page", skip_request: true do
          expect { action }.to change(Page, :count).by(1)
        end
        it "assigns a newly created page as @page" do
          expect(assigns(:page)).to be_a(Page)
          expect(assigns(:page)).to be_persisted
        end
        it { should redirect_to(Page.last) }
      end

      context "with invalid params" do
        let(:action) { post :create, page: invalid_attributes }
        it "assigns a newly created but unsaved page as @page" do
          action
          expect(assigns(:page)).to be_a_new(Page)
        end
        it "re-renders the 'new' template" do
          action
          expect(response).to render_template("new")
        end
      end
    end
  end

  describe "PUT #update" do
    let(:new_attributes) { { title: 'foo' } }
    let(:action) { put :update, id: page, page: new_attributes }

    it_should_behave_like 'an authorized action'
    context "when authorized", authorized: true do
      before { action }
      context "with valid params" do
        it "updates the requested page" do
          expect(page.reload.title).to eq 'foo'
        end
        it "assigns the requested page as @page" do
          expect(assigns(:page)).to eq(page)
        end
        it { should redirect_to page }
      end

      context "with invalid params" do
        let(:new_attributes) { { title: nil } }
        it "assigns the page as @page" do
          expect(assigns(:page)).to eq(page)
        end
        it { should render_template :edit }
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:page) { create(:page) }
    let(:action) { delete :destroy, id: page.to_param }
    it_should_behave_like 'an authorized action'
    context "when authorized", authorized: true do
      before {|ex| action unless ex.metadata[:skip_request] }
      it "destroys the requested page", skip_request: true do
        expect { action }.to change(Page, :count).by(-1)
      end
      it { should redirect_to action: :index }
    end
  end

end
