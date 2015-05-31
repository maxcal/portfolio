require 'rails_helper'

RSpec.describe Site::Configuration, type: :model do
  it { should validate_uniqueness_of :name }
  it { should validate_presence_of :site_title }
  it { should respond_to :active? }
  it { should respond_to :disabled? }

  it 'should only allow a single active configuration' do
    config1 = create(:config, status: :active)
    config2 = create(:config, status: :active)
    expect(config1.reload.active?).to be_falsey
    expect(config2.reload.active?).to be_truthy
  end
end
