require 'rails_helper'
require 'support/omniauth'

RSpec.describe Authentication do
  it { should validate_uniqueness_of :uid }
  it { should belong_to :user }
end