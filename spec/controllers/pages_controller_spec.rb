require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  subject { response }

  describe "GET #home" do
    before { get :home }
    it { should have_http_status(:success) }
    it { should render_template(:home) }
  end

end
