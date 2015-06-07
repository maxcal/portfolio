require 'rails_helper'

RSpec.feature "Page management", type: :feature do
  let(:user) { create(:admin) }
  background { login_as user }
  let(:the_page) { create(:page) }

  scenario "I can create a new page" do
    visit root_path
    click_link 'Pages'
    click_link 'New'
    fill_in 'Title', with: 'Test Title'
    click_button 'Create Page'
    expect(page).to have_content 'Test Title'
    expect(current_path).to eq page_path(Page.last)
  end

  scenario "I can edit a page" do
    visit page_path(the_page)
    click_link 'Edit'
    fill_in 'Title', with: 'New Title'
    click_button 'Update Page'
    expect(page).to have_content 'New Title'
  end

  scenario "I can delete a page" do
    visit page_path(the_page)
    click_link 'Delete'
    expect(page).to_not have_content the_page.title
  end
end
