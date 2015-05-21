require 'rails_helper'

RSpec.describe PermissionsHelper, type: :helper do

  let(:resource) { build_stubbed(:photoset) }
  let(:ability) do
    Object.new.extend(CanCan::Ability)
  end

  before { allow(controller).to receive('current_ability').and_return(ability) }
  describe '.crud_links_for_resource' do
    let(:buttons) { |ex|
      helper.crud_links_for_resource(resource, data: { foo: 'bar' }).values
    }
    let(:node) { Capybara::Node::Simple.new(buttons.join) }
    subject { node }

    describe 'destroy link' do
      context 'when authorized' do
        before do
          ability.can :destroy, resource
        end
        let(:link) { node.find_link(I18n.t('photoset.destroy')) }
        it 'has the correct method' do
          expect(link["data-method"]).to eq "delete"
        end
        it 'has the correct url' do
          expect(link[:href]).to eq url_for(resource)
        end
        it "accepts a hash of options to pass to link_to" do
          expect(link['data-foo']).to eq 'bar'
        end
        it 'has a confirmation' do
          expect(link["data-confirm"]).to eq I18n.t('photoset.confirm_destroy')
        end
      end
      context 'when unauthorized' do
        it { should_not have_link I18n.t('photoset.destroy') }
      end
    end

    describe 'destroy link' do
      context 'when authorized' do
        before do
          ability.can :edit, resource
        end
        let(:link) { node.find_link(I18n.t('photoset.edit')) }
        it 'has the correct url' do
          expect(link[:href]).to eq edit_photoset_path(resource)
        end
      end
      context 'when unauthorized' do
        it { should_not have_link I18n.t('photoset.edit') }
      end
    end

    describe 'new link' do
      let(:resource) { Photoset }
      let(:link) { node.find_link(I18n.t('photoset.new')) }
      before do
        ability.can :create, resource
      end
      it 'has the correct url' do
        expect(link[:href]).to eq new_photoset_path
      end
    end

  end
end
