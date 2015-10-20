require 'rails_helper'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  #it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:email) }
  it { is_expected.to respond_to(:password_digest) }
  it { is_expected.to respond_to(:password) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:admin) }
  it { is_expected.to respond_to(:authenticate) }
  it { is_expected.to respond_to(:password_confirmation) }
  it { is_expected.to respond_to(:remember_token) }
  it { is_expected.to respond_to(:microposts) }
  it { is_expected.to respond_to(:feed) }
  it { is_expected.to respond_to(:relationships) }
  it { is_expected.to respond_to(:followed_users) }
  it { is_expected.to respond_to(:reverse_relationships) }
  it { is_expected.to respond_to(:followers) }
  it { is_expected.to respond_to(:following?) }
  it { is_expected.to respond_to(:follow!) }
  it { is_expected.to respond_to(:unfollow!) }

  it { is_expected.to be_valid }
  it { is_expected.not_to be_admin }

  # describe "accessible attributes" do
  #   it "should not allow access to admin" do
  #     expect do
  #       User.new(admin: "1")
  #     end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #   end
  # end

  describe "with admin attribute set to 'true'" do
    before { @user.toggle!(:admin) }

    it { is_expected.to be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "when email format is invalid" do
    it "is_expected.to be invalid" do
      addresses = %w[user@foo,com user_at_fool.org eample.user@foo. 
        foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "is_expected.to be_valid" do
      addresses = %w[user@foo.com THE_US-ER@f.b.org first.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { is_expected.not_to be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { is_expected.not_to be_valid }
  end

  describe "when password_confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { is_expected.not_to be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { is_expected.not_to be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      #it { is_expected.to == found_user.authenticate(@user.password) }
      it { is_expected.to eq(found_user.authenticate(@user.password)) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") } 
      #it { should_not == user_for_invalid_password }
      it { is_expected.not_to eq(user_for_invalid_password) }
      #specify { user_for_invalid_password.should be_falsey }
      specify { expect(user_for_invalid_password).to be_falsey }
    end  
  end

  describe "remember token" do
    before { @user.save }
    it "should have a nonblank remember token" do
      #its(:remember_token) { should_not be_blank }
      expect(@user.remember_token).not_to be_blank
    end
  end

  describe "micropost associations" do
    # Call save to generate user.id
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts).to eq([newer_micropost, older_micropost])
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts
      @user.destroy
      microposts.each do |micropost|
        expect(Micropost.find_by_id(micropost.id)).to be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      it "should include older and newer microposts but not unfollowed post" do
        #its(:feed) { is_expected.to include(:older_micropost) }
        expect(@user.feed).to include(older_micropost)
        expect(@user.feed).to include(newer_micropost)
        expect(@user.feed).not_to include(unfollowed_post)
      end

      it "user feed should include microposts of followed users" do
        followed_user.microposts.each do |micropost|
          expect(@user.feed).to include(micropost)
        end
      end
    end

    describe "following" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        @user.save
        @user.follow!(other_user)
      end

      it { is_expected.to be_following(other_user) }

      it "followed users should include other users" do
        expect(@user.followed_users).to include(other_user)
      end

      describe "followed user" do
        it "other user's followers should include user" do
          expect(other_user.followers).to include(@user)
        end
      end

      describe "and unfollowing" do
        before { @user.unfollow!(other_user) }

        it "should not be following other user" do
          expect(@user).not_to be_following(other_user)
          expect(@user.followed_users).not_to include(other_user)
        end
      end
    end
  end
end