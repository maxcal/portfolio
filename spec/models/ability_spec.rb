require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability do
  let(:user) { build_stubbed(:user) }
  let(:ability) { Ability.new(user) }
  subject { ability }

  context 'guest users' do
    it { should be_able_to :read, User }
    it { should be_able_to :read, Photoset }
    it { should be_able_to :crud, user }
    it { should_not be_able_to :crud, User }
    it { should be_able_to :read, Photoset }
    it { should_not be_able_to :crud, Photoset }
    it { should be_able_to :read, Page }
    it { should_not be_able_to :crud, Page }
  end

  context 'admins' do
    let(:user) { build_stubbed(:admin) }
    it { should be_able_to :crud, Photoset }
    it { should be_able_to :crud, Site::Configuration }
    it { should be_able_to :crud, Page }
  end
end