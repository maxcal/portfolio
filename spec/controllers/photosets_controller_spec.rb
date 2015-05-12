require 'rails_helper'
require 'support/shared_examples/controllers'

RSpec.describe PhotosetsController, type: :controller do

  subject { response }
  let(:photoset) { create(:photoset) }

  before do |example|
    set_current_user(example.metadata[:valid_session] ? create(:admin) : nil)
  end

  describe 'GET #show' do
    before { get :show, id: photoset }
    it { should have_http_status :success }
    it { should render_template :show }
    it "assigns Photoset as @photoset" do
      expect(assigns(:photoset)).to eq photoset
    end
  end

  describe 'GET #index' do
    before do
      photoset
      get :index
    end
    it { should have_http_status :success }
    it { should render_template :index }
    it "assigns photosets as @photosets" do
      expect(assigns(:photosets).first).to eq photoset
    end
  end

  describe 'GET #new' do

    it_should_behave_like "an authorized action" do
      let(:action) { get :new }
    end

    context 'when authorized', valid_session: true do
      before { get :new }
      it { should have_http_status :success }
      it { should render_template :new }
      it "assigns photosets as @photosets" do
        expect(assigns(:photoset)).to be_a Photoset
      end
    end
  end

  describe 'POST #create' do
    let(:action) { post :create, photoset: attributes_for(:photoset) }

    it_should_behave_like "an authorized action"

    context 'when authorized', valid_session: true do
      before do |example|
        allow_any_instance_of(Photoset)
          .to receive(:valid?).and_return(false) if example.metadata[:invalid]
        action unless example.metadata[:skip_request]
      end
      context 'with valid params' do
        it "creates a photoset", skip_request: true do
          expect {
            action
          }.to change(Photoset, :count).by(+1)
        end
        it { should redirect_to assigns(:photoset) }
      end
      context 'with invalid params', invalid: true do
        it { should render_template :new }
      end
    end
  end

  describe 'GET #edit' do
    let(:action) { get :edit, id: photoset }
    it_should_behave_like "an authorized action"

    context 'when authorized', valid_session: true do
      before { action }


      it { should have_http_status :success }
      it { should render_template :edit }
      it 'assigns photoset as @photoset' do
        expect(assigns(:photoset)).to eq photoset
      end
    end
  end

  describe 'POST #update' do
    let(:action) do
      patch :update, id: photoset, photoset: { title: 'Updated Title', description: 'Updated Description' }
    end

    it_should_behave_like "an authorized action"

    context 'when authorized', valid_session: true do
      before do |example|
        if example.metadata[:invalid]
          create(:photoset, title: 'Updated Title')
        end
        action unless example.metadata[:skip_request]
      end

      context 'with valid params' do
        it { should redirect_to assigns(:photoset) }
        it 'updates the photoset' do
          expect(assigns(:photoset).title).to eq 'Updated Title'
          expect(assigns(:photoset).description).to eq 'Updated Description'
        end
      end

      context 'with invalid params', invalid: true do
        it { should render_template :edit }
        it "does not update the photoset" do
          expect(photoset.reload.description).to_not eq assigns(:photoset).description
          expect(photoset.reload.title).to_not eq assigns(:photoset).title
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:action) do
      delete :destroy, id: photoset
    end

    it_should_behave_like "an authorized action"

    context 'when authorized', valid_session: true do
      before { action }
      it 'destroys the photoset' do
        expect(assigns(:photoset).destroyed?).to be_truthy
      end
      it { should redirect_to action: :index }
    end
  end
end
