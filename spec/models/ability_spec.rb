require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do

  let(:user) { build_stubbed(:user) }
  let(:ability) { Ability.new(user) }
  subject { ability }

  context 'guest users' do
    it { should be_able_to :read, User }
    it { should be_able_to :crud, user }
    it { should_not be_able_to :crud, User }
  end

  context 'admins' do
    before do
      user.add_role(:admin)
    end
  end
end