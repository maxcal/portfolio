require 'rails_helper'
require 'support/javascript_test_helpers'

RSpec.feature 'Importing photosets from flickr' do

  include JavascriptTestHelpers

  let(:user) { create(:admin, flickr_uid: '62829091@N05') }

  background do
    login_as user
    VCR.use_cassette('photosets_import') { visit new_photoset_path }
  end

  scenario 'when I import a photoset I should be notified when it succeeds', js: true do
    VCR.use_cassette('create_a_photoset') do
      click_button('Create Photoset', match: :first)
      wait_for_ajax
    end
    expect(page).to have_content I18n.t('photosets.flash.create.success')
  end

  scenario 'I should not be able to re-import the same photoset', js: true do
    VCR.use_cassette('create_a_photoset') do
      click_button('Create Photoset', match: :first)
      wait_for_ajax
    end
    expect(first('.photoset')).to_not have_button 'Create Photoset'
  end

  scenario 'When I create a photoset it should have the correct attributes', js: true do
    # This basically tests that the mapping in javascript between fields and params is correct
    VCR.use_cassette('create_a_photoset') do
      click_button('Create Photoset', match: :first)
      wait_for_ajax
    end
    find('.photoset', match: :first).click
    expect(page).to have_content "Showcase"
    expect(page).to have_content "Like a greatest hits collection, but with snow."
    expect(page).to have_selector '.photo img', count: 10
  end
end