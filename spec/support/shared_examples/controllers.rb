RSpec.shared_examples "an authorized action" do
  it "denies access when unauthorized" do
    expect {
      action
    }.to raise_error(CanCan::AccessDenied)
  end
end