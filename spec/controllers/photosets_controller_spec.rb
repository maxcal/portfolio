require 'rails_helper'
require 'support/shared_examples/controllers'

RSpec.describe PhotosetsController, type: :controller do

  subject { response }
  let(:photoset) { create(:photoset) }
  let(:params) {|e| {format: e.metadata[:format]}}
  let(:admin) { create(:admin, flickr_uid: '62829091@N05') }

  before do |example|
    set_current_user(example.metadata[:valid_session] ? admin : nil)
  end

  shared_examples "a singular resource representation" do
    it "should assign user as @user" do
      expect(assigns(:photoset).id).to eq photoset.id
    end
  end

  describe 'GET #show' do
    before { |e| get :show, id: photoset, format: e.metadata[:format] }
    it { should have_http_status :success }
    it { should render_template :show }
    it_should_behave_like "a singular resource representation"
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

    let(:action) { get :new }

    it_should_behave_like 'an authorized action'
    context 'when authorized', valid_session: true do
      before { VCR.use_cassette('photosets_import') { action } }
      it { should have_http_status :success }
      it { should render_template :new }
      it "assigns photosets as @photosets" do
        expect(assigns(:photosets).first).to be_a_new Photoset
      end
    end
  end

  describe 'POST #create' do
    let(:action) do |e|
      VCR.use_cassette('creating_a_photoset') do
        post :create,
             photoset: attributes_for(:photoset, flickr_uid: '72157642806447225'),
             format: e.metadata[:format]
      end
    end

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
        it 'gets photos' do
          expect(assigns(:photoset).photos.count).to eq 11
        end
      end
      context 'with invalid params', invalid: true do
        it { should render_template :new }
        it { should have_http_status :ok }
      end
      context 'as JSON', format: :json do
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
    let(:action) {  |ex| delete :destroy, id: photoset, format: ex.metadata[:format] }
    shared_examples 'destroys the photoset' do
      it 'destroys the photoset' do
        expect(assigns(:photoset).destroyed?).to be_truthy
      end
    end
    it_should_behave_like "an authorized action"
    context 'when authorized', valid_session: true do
      before { action }
      include_examples 'destroys the photoset'
      it { should redirect_to action: :index }
      it 'flashes a message' do
        expect(controller.flash[:notice]).to eq I18n.t('photosets.flash.destroy.success')
      end
      context 'as JSON', format: :json do
        include_examples 'destroys the photoset'
        it { should have_http_status :no_content }
      end
    end
  end
end
