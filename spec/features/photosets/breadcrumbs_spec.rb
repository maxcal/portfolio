require 'rails_helper'

RSpec.feature "Page breadcrumbs", type: :feature do

  let(:photoset) { create(:photoset) }
  background { login_as( create(:admin) ) }

  scenario 'I should see the correct breadcrumbs on the photosets index' do
    visit photosets_path
    expect(page).to have_selector '.current', text: 'Photosets'
  end

  scenario 'I should see the correct breadcrumbs when visiting a photoset' do
    visit photoset_path(photoset)
    expect(page).to have_link 'Photosets', href: photosets_path
    expect(page).to have_selector '.current', text: photoset.title
  end

  scenario 'I should see the correct breadcrumbs when creating a photoset' do
    allow_any_instance_of( PhotosetServices::GetList).to receive(:call).and_return([Photoset.new])
    visit new_photoset_path
    expect(page).to have_link 'Photosets', href: photosets_path
    expect(page).to have_selector '.current', text: "New photoset"
  end
end