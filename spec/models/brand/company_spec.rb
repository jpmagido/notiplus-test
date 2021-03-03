require 'rails_helper'

RSpec.describe Brand::Company, type: :model do
  include_context 'actions'
  include_context 'auth0'

  describe 'relations' do
    let(:brand_company) do
      create(
          :brand_company,
          brand_accounts: [
              create(
                  :brand_account,
                  brand_members: [
                      create(:brand_member)
                  ]
              )
          ]
      )
    end

    it { expect(brand_company.brand_accounts.length).to be >= 1 }
    it { expect(brand_company.brand_members.length).to be >= 1 }
    it { expect(brand_company.user_accounts.length).to be >= 1 }
  end

  describe 'accepted APE' do
    label = siret_lookup_response[:uniteLegale][:periodesUniteLegale][0][:nomUniteLegale]
    let(:ape_code) { siret_lookup_response[:uniteLegale][:periodesUniteLegale][0][:activitePrincipaleUniteLegale] }
    let(:brand_company) { build_stubbed(:brand_company, owner_id: user_account_success.id, label: ape_code) }

    it 'should create a valid company' do
      expect(brand_company).to be_valid
    end
  end

  describe 'denied APE' do
    label = siret_lookup_response_failed[:uniteLegale][:periodesUniteLegale][0][:nomUniteLegale]
    let(:ape_code) { siret_lookup_response_failed[:uniteLegale][:periodesUniteLegale][0][:activitePrincipaleUniteLegale] }
    let(:brand_company) { build_stubbed(:brand_company, owner_id: user_account_fail.id, label: ape_code) }

    it 'should create a valid company' do
      expect(brand_company).not_to be_valid
    end
  end
end
