require 'rails_helper'

RSpec.describe Brand::Member, type: :model do
  include_context 'actions'
  include_context 'auth0'

  let(:ape_code) { siret_lookup_response[:uniteLegale][:periodesUniteLegale][0][:activitePrincipaleUniteLegale] }
  let(:brand_company) { create(:brand_company, owner_id: user_account_success.id, label: ape_code) }
  let(:brand_account) { create(:brand_account, brand_company_id: brand_company.id, label: brand_company.label) }

  let(:member) { create(:brand_member, brand_account_id: brand_account.id, user_account_id: user_account_success.id)}

  it 'should create aa valid instance of Brand::Member' do
    expect(member).to be_valid
  end

  describe 'relations' do
    let(:brand_member) do
      build_stubbed(
        :brand_member,
        user_account: create(:user_account)
      )
    end

    it { expect(brand_member.user_account).not_to be nil }
    it { expect(brand_member.brand_account).not_to be nil }
  end
end
