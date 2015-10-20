require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { is_expected.to be_valid }

  describe "follower methods" do
    it { is_expected.to respond_to(:follower) }
    it { is_expected.to respond_to(:followed) }
    specify { expect(relationship.follower).to eq(follower) }
    specify { expect(relationship.followed).to eq(followed) }
  end

  describe "when follower id is not present" do
    before { relationship.followed_id = nil }
    it { is_expected.not_to be_valid }
  end

  describe "when followed id is not present" do
    before { relationship.followed_id = nil }
    it { is_expected.not_to be_valid }
  end
end
