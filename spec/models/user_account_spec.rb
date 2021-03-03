require 'rails_helper'

RSpec.describe UserAccount, type: :model do
  before { @user_email = 'testmail@rspec.com' }
  include_context 'auth0'

  describe 'missing auth0_uid' do
    let(:user) { build_stubbed(:user_account, auth0_uid: nil) }

    it { expect(user.valid?).to be false }
  end

  describe 'auth0_uid success' do
    it 'should create a valid user_account' do
      expect(user_account_success).to be_valid
    end
  end

  describe 'auth0_uid fail' do
    it 'should not create a valid user_account' do
      expect(user_account_fail).not_to be_valid
    end
  end

  describe 'relations' do
    let(:user) do
      create(
          :user_account,
          brand_member: create(:brand_member)
      )
    end

    it { expect(user.brand_member).not_to be nil }
    it { expect(user.brand_account).not_to be nil }
    it { expect(user.brand_company).not_to be nil }
  end
end
