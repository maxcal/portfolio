require 'rails_helper'
require 'support/omniauth'

RSpec.feature 'Flickr Authentication' do

  let(:sign_in_via_flickr) do
    visit root_path
    click_link I18n.t('sessions.menu.sign_in_with_flickr')
  end

  context 'with a successfull flickr auth' do
    before { mock_flickr_authentication(mock_auth_hash) }
    scenario 'when I click log in, I should be logged in via Flickr' do
      sign_in_via_flickr
      expect(page).to have_content I18n.t('sessions.flash.you_have_been_signed_in')
    end
    scenario 'I should be logged out' do
      sign_in_via_flickr
      click_link( I18n.t('sessions.menu.sign_out'))
      expect(page).to have_content I18n.t('sessions.flash.you_have_been_signed_out')
    end
  end
  context 'with a failed authentication' do
    before { mock_failed_flickr_authentication }
    scenario 'I should be notified that sign in failed' do
      sign_in_via_flickr
      expect(page).to have_content I18n.t('auth.failure.flashes.invalid_credentials')
    end
    scenario 'I should not be logged in' do
      sign_in_via_flickr
      expect(page).to_not have_content I18n.t('sessions.flash.you_have_been_signed_in')
      expect(page).to_not have_link(I18n.t('sessions.menu.sign_out'))
    end
  end
end