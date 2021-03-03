require 'rails_helper'

RSpec.describe Brand::Company, type: :model do
  include_context 'actions'

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
    let(:ape_code) { siret_lookup_response[:uniteLegale][:periodesUniteLegale][0][:activitePrincipaleUniteLegale] }
    let(:brand_company) { create(:brand_company, label: ape_code) }

    it 'should create a valid company' do
      expect(brand_company).to be_valid
    end
  end

  describe 'denied APE' do
    let(:ape_code) { siret_lookup_response_failed[:uniteLegale][:periodesUniteLegale][0][:activitePrincipaleUniteLegale] }
    let(:brand_company) { build(:brand_company, label: ape_code) }

    it 'should create a valid company' do
      expect(brand_company).not_to be_valid
    end
  end
end
