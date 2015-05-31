require 'rails_helper'
require 'support/shared_examples/controllers'

RSpec.describe Site::ConfigurationsController, type: :controller do

  let(:config) { create(:config) }
  let(:admin) { build_stubbed(:admin) }

  before do |example|
    set_current_user(example.metadata[:authorized] ? admin : nil)
  end

  subject { response }

  describe "GET #index" do
    let(:action) { get :index }
    before { config }
    it_should_behave_like 'an authorized action'

    context "when authorized", authorized: true do
      before { action }
      it { should have_http_status :success }
      it { should render_template :index }
      it "assigns all site_configurations as @site_configurations" do
        expect(assigns(:site_configurations)).to eq([config])
      end
    end
  end

  describe "GET #show" do
    let(:action) { get :show, id: config }
    it_should_behave_like 'an authorized action'

    context "when authorized", authorized: true do
      before { action }
      it { should have_http_status :success }
      it { should render_template :show }
      it "assigns the requested site_configuration as @site_configuration" do
        expect(assigns(:site_configuration)).to eq(config)
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
      it "assigns a new site_configuration as @site_configuration" do
        expect(assigns(:site_configuration)).to be_a_new(Site::Configuration)
      end
    end
  end

  describe "GET #edit" do
    let(:action) { get :edit, id: config }
    it_should_behave_like 'an authorized action'

    context "when authorized", authorized: true do
      before { action }
      it { should render_template :edit }
      it { should have_http_status :success }
      it "assigns the requested site_configuration as @site_configuration" do
        expect(assigns(:site_configuration)).to eq(config)
      end
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { attributes_for(:config) }
    let(:invalid_attributes) { { site_title: nil } }
    let(:action) { post :create, site_configuration: valid_attributes  }

    it_should_behave_like 'an authorized action'

    context "when authorized", authorized: true do
      before {|ex| action unless ex.metadata[:skip_request] }

      context "with valid params" do
        it "creates a new Site::Configuration", skip_request: true do
          expect { action }.to change(Site::Configuration, :count).by(1)
        end
        it "assigns a newly created site_configuration as @site_configuration" do
          expect(assigns(:site_configuration)).to be_a(Site::Configuration)
          expect(assigns(:site_configuration)).to be_persisted
        end
        it { should redirect_to(Site::Configuration.last) }
      end

      context "with invalid params" do
        let(:action) { post :create, { site_configuration: invalid_attributes } }
        it "assigns a newly created but unsaved site_configuration as @site_configuration" do
          action
          expect(assigns(:site_configuration)).to be_a_new(Site::Configuration)
        end
        it "re-renders the 'new' template" do
          action
          expect(response).to render_template("new")
        end
      end
    end
  end

  describe "PUT #update" do
    let(:new_attributes) { { site_title: 'foo' } }
    let(:action) { put :update, id: config.to_param, site_configuration: new_attributes }

    it_should_behave_like 'an authorized action'
    context "when authorized", authorized: true do
      before { action }
      context "with valid params" do
        it "updates the requested site_configuration" do
          expect(config.reload.site_title).to eq 'foo'
        end
        it "assigns the requested site_configuration as @site_configuration" do
          expect(assigns(:site_configuration)).to eq(config)
        end
        it { should redirect_to config }
      end

      context "with invalid params" do
        let(:new_attributes) { { site_title: nil } }
        it "assigns the site_configuration as @site_configuration" do
          expect(assigns(:site_configuration)).to eq(config)
        end
        it { should render_template :edit }
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:config) { create(:config) }
    let(:action) { delete :destroy, id: config.to_param }
    it_should_behave_like 'an authorized action'
    context "when authorized", authorized: true do
      before {|ex| action unless ex.metadata[:skip_request] }
      it "destroys the requested site_configuration", skip_request: true do
        expect { action }.to change(Site::Configuration, :count).by(-1)
      end
      it { should redirect_to action: :index }
    end
  end
end