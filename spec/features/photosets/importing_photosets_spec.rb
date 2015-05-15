require 'rails_helper'
require 'support/javascript_test_helpers'

RSpec.feature 'Importing photosets from flickr' do

  include JavascriptTestHelpers

  let(:user) { create(:admin) }

  background do
    login_as user
    VCR.use_cassette('photosets_import') { visit new_photoset_path }
  end

  scenario 'when I import a photoset I should be notified when it succeeds', js: true do
    click_button('Create Photoset', match: :first)
    wait_for_ajax
    expect(page).to have_content I18n.t('photosets.flash.create.success')
  end

  scenario 'I should not be able to re-import the same photoset', js: true do
    click_button('Create Photoset', match: :first)
    wait_for_ajax
    expect(first('.photoset')).to_not have_button 'Create Photoset'
  end

  scenario 'When I create a photoset it should have the correct attributes', js: true do
    # This basically tests that the mapping in javascript between fields and params is correct
    click_button('Create Photoset', match: :first)
    wait_for_ajax
    set = Photoset.last
    # Values are from /support/vcr_cassettes/photosets_import.yml
    expect(set.flickr_uid).to eq "72157647753138397"
    expect(set.title).to eq "Showcase"
    expect(set.user_id).to eq user.id
    expect(set.description).to eq "Test description"
    expect(set.primary_photo.flickr_uid).to eq '13362508473'
  end
end