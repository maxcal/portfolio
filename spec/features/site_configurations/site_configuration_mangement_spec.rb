require 'rails_helper'

RSpec.describe 'Site configuration management' do

  let(:user) { create(:admin) }
  before { login_as user }

  scenario 'I should be able to create a site configuration' do
    visit '/'
    click_link 'Settings'
    click_link 'New'
    fill_in 'Name', with: 'Test Settings'
    fill_in 'Site title', with: 'Just Testing'
    click_button 'Create Configuration'
    expect(page).to have_content 'Test Settings'
    expect(page).to have_content 'Just Testing'
  end

  scenario "I can change the title on the site" do
    visit new_site_configuration_path
    fill_in 'Name', with: 'Test Settings'
    fill_in 'Site title', with: 'Just Testing'
    select 'active', from: 'Status'
    click_button 'Create Configuration'
    expect(page.title).to match 'Just Testing'
  end

  scenario "I can edit a configuration" do
    create(:config)
    visit site_configurations_path
    click_link 'Edit'
    fill_in 'Site title', with: 'Just Testing'
    click_button 'Update Configuration'
    expect(page).to have_content 'Just Testing'
  end

  scenario "I can delete a configuration" do
    config = create(:config)
    visit site_configurations_path
    click_link 'Destroy'
    expect(page).to_not have_content config.name
  end
end