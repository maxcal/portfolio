require 'rails_helper'
require 'support/javascript_test_helpers'

RSpec.feature 'Deleting photosets from flickr' do

  let!(:photoset) { create(:photoset) }
  let(:user) { create(:admin) }

  before { login_as user }

  scenario "when I delete a photoset it gives a success notification" do
    visit photoset_path(photoset)
    click_link I18n.t('photosets.show.destroy')
    expect(page).to have_content I18n.t('photosets.flash.destroy.success')
  end

  scenario "when I delete a photoset it redirects to the index page" do
    visit photoset_path(photoset)
    click_link I18n.t('photosets.show.destroy')
    expect(current_path).to match photosets_path
  end

  scenario "when I delete a photoset it should not be listed in the index" do
    visit photoset_path(photoset)
    click_link I18n.t('photosets.show.destroy')
    expect(page).to_not have_content photoset.title
  end
end