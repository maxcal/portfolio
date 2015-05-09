require 'rails_helper'

RSpec.describe Authentication do
  it { should validate_uniqueness_of :uid }
end
