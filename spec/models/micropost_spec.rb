require 'rails_helper'

RSpec.describe Micropost, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  let(:user) { FactoryGirl.create(:user) }

  before do
    @micropost = user.microposts.build(content: "Lorem ipsum")
  end

  subject { @micropost }

  it { is_expected.to respond_to(:content) }
  it { is_expected.to respond_to(:user_id) }
  it { is_expected.to respond_to(:user) }

  it { is_expected.to be_valid }

  # there's no need in Rails 4 to test for mass assignment issues in Rspec model tests. 
  # The whole idea of Rails 4's Strong Parameters is to move all that functionality to 
  # the controller.
  # describe "accessible attributes" do
  #   it "should not allow access to user_id" do
  #     expect do
  #       Micropost.new(user_id: "1")
  #     end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #   end
  # end

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe "with blank content" do
    before { @micropost.content = " " }
    it { is_expected.not_to be_valid }
  end

  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { is_expected.not_to be_valid }
  end
end
