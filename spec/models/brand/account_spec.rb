require 'rails_helper'

RSpec.describe Brand::Account, type: :model do
  include_context 'actions'
  include_context 'auth0'

  let(:ape_code) { siret_lookup_response[:uniteLegale][:periodesUniteLegale][0][:activitePrincipaleUniteLegale] }
  let(:brand_company) { create(:brand_company, owner_id: user_account_success.id, label: ape_code) }
  let(:account) { create(:brand_account, brand_company_id: brand_company.id, label: brand_company.label) }

  it 'should create a valid instance of Brand::Account' do
    expect(account).to be_valid
  end

  describe 'relations' do
    let(:brand_account) do
      build_stubbed(
          :brand_account,
          brand_members: [
              build_stubbed(:brand_member)
          ]
      )
    end

    it { expect(brand_account.brand_members.length).to be >= 1 }
  end
end
