require 'rails_helper'

RSpec.feature "Page breadcrumbs", type: :feature do

  let(:site_configuration) { create(:config) }
  background { login_as( create(:admin) ) }

  scenario 'I should see the correct breadcrumbs on the configurations index' do
    visit site_configurations_path
    expect(page).to have_selector '.current', text: 'Configurations'
  end

  scenario 'I should see the correct breadcrumbs when visiting a site_configuration' do
    visit site_configuration_path(site_configuration)
    expect(page).to have_link 'Configurations', href: site_configurations_path
    expect(page).to have_selector '.current', text: site_configuration.name
  end

  scenario 'I should see the correct breadcrumbs when creating a site_configuration' do
     visit new_site_configuration_path
    expect(page).to have_link 'Configurations', href: site_configurations_path
    expect(page).to have_selector '.current', text: "New configuration"
  end

  scenario 'I should see the correct breadcrumbs when editing a site_configuration' do
    visit edit_site_configuration_path(site_configuration)
    expect(page).to have_link 'Configurations', href: site_configurations_path
    expect(page).to have_selector '.current', text: "Edit #{site_configuration.name}"
  end
end