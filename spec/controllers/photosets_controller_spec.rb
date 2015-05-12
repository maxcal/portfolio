require 'rails_helper'
require 'support/shared_examples/controllers'

RSpec.describe PhotosetsController, type: :controller do

  subject { response }
  let(:photoset) { create(:photoset) }
  let(:params) {|e| {format: e.metadata[:format]}}
  let(:admin) { create(:admin) }

  before do |example|
    set_current_user(example.metadata[:valid_session] ? admin : nil)
  end

  describe 'GET #show' do
    before { |e| get :show, id: photoset, format: e.metadata[:format] }
    it { should have_http_status :success }
    it { should render_template :show }
    it "assigns Photoset as @photoset" do
      expect(assigns(:photoset)).to eq photoset
    end

    context 'as JSON', format: :json do
      it { should have_http_status :success }
    end
  end

  describe 'GET #index' do
    before do |e|
      photoset
      get :index, format: e.metadata[:format]
    end
    it { should have_http_status :success }
    it { should render_template :index }
    it 'assigns photosets as @photosets' do
      expect(assigns(:photosets).first).to eq photoset
    end

    context 'as JSON', format: :json do
      it { should have_http_status :success }
    end
  end

  describe 'GET #new' do

    it_should_behave_like 'an authorized action' do
      let(:action) { get :new }
    end

    context 'when authorized', valid_session: true do
      before { |e| get :new }
      it { should have_http_status :success }
      it { should render_template :new }
      it "assigns photosets as @photosets" do
        expect(assigns(:photoset)).to be_a Photoset
      end
    end
  end

  describe 'POST #create' do
    let(:action) { |e| post :create, photoset: attributes_for(:photoset), format: e.metadata[:format] }

    it_should_behave_like "an authorized action"

    context 'when authorized', valid_session: true do
      before do |example|
        allow_any_instance_of(Photoset)
          .to receive(:valid?).and_return(false) if example.metadata[:invalid]
        action unless example.metadata[:skip_request]
      end
      context 'with valid params' do
        it 'creates a photoset', skip_request: true do
          expect {
            action
          }.to change(Photoset, :count).by(+1)
          expect(assigns(:photoset)).to be_persisted
        end
        it { should redirect_to assigns(:photoset) }

        it 'assigns user to photoset' do
          expect(assigns(:photoset).user).to eq admin
        end
      end
      context 'with invalid params', invalid: true do
        it { should render_template :new }
      end
      context 'as JSON', format: :json do
        let(:action) { |e| post :create, photoset: attributes_for(:photoset), format: :json }
        it { should have_http_status :created }
      end
    end
  end

  describe 'GET #edit' do
    let(:action) { get :edit, id: photoset }
    it_should_behave_like 'an authorized action'
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
    let(:action) do |e|
      patch :update, id: photoset,
                     photoset: { title: 'Updated Title', description: 'Updated Description' },
                     format: e.metadata[:format]
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

      context 'as JSON', format: :json do
        it { should have_http_status :no_content }
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

      context 'as JSON', format: :json do
        it { should have_http_status :found }
      end
    end
  end
end
