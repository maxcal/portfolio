require 'rails_helper'

RSpec.feature "Page breadcrumbs", type: :feature do

  let(:the_page) { create(:page) }
  background { login_as( create(:admin) ) }

  scenario 'I should see the correct breadcrumbs on the pages index' do
    visit pages_path
    expect(page).to have_selector '.current', text: 'Pages'
  end

  scenario 'I should see the correct breadcrumbs when visiting a page' do
    visit page_path(the_page)
    expect(page).to have_link 'Pages', href: pages_path
    expect(page).to have_selector '.current', text: the_page.title
  end

  scenario 'I should see the correct breadcrumbs when editing a page' do
    visit edit_page_path(the_page)
    expect(page).to have_link 'Pages', href: pages_path
    expect(page).to have_selector '.current', text: "Editing #{the_page.title}"
  end

  scenario 'I should see the correct breadcrumbs when creating a page' do
    visit new_page_path
    expect(page).to have_link 'Pages', href: pages_path
    expect(page).to have_selector '.current', text: "New page"
  end
end