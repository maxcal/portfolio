require 'rails_helper'

RSpec.feature "Refreshing a photoset" do

  let(:user) { create(:admin) }
  background { login_as user }

  let!(:photoset) { create(:photoset, flickr_uid: "72157647753138397", user: user) }
  scenario 'when I click update on a photoset' do
    visit photoset_path(photoset)
    VCR.use_cassette('refreshing_a_photoset') do
      click_link(I18n.t('photoset.refresh'))
    end
    expect(page).to have_content I18n.t('photosets.flash.update.success')
  end
end