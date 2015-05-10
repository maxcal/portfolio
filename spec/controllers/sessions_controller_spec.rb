require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  subject { response }

  describe "DELETE #destroy" do

    before do
      # Stub out warden.
      warden = double('warden')
      expect(warden).to receive(:logout)
      request.env['warden'] = warden
      delete :destroy
    end

    it { should redirect_to :root }
  end
end