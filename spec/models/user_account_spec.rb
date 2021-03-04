require 'rails_helper'

RSpec.describe UserAccount, type: :model do
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
