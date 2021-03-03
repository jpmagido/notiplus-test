FactoryBot.define do
  factory :brand_company, class: 'Brand::Company' do
    association :owner, factory: :user_account
    label { (AUTHORIZED_NOTARY_CODES + AUTHORIZED_REALTOR_CODES).sample }
    siren_number { SecureRandom.uuid }
  end
end
