require 'rails_helper'

RSpec.feature "User profile management" do

  let!(:user) { create(:user) }

  background do
    login_as user
  end

  scenario "a user can edit his profile" do
    visit root_path
    click_link I18n.t('sessions.menu.profile')
    click_link I18n.t('crud_buttons.edit')
    page.fill_in I18n.t('simple_form.labels.user.name'), with: 'New Name'
    click_button 'Update User'
    expect(page).to have_content 'New Name'
  end

  scenario "a user can view index" do
    visit users_path
    expect(page).to have_link user.nickname
  end
end