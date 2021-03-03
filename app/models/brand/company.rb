class Brand::Company < ApplicationRecord
  belongs_to :owner, class_name: 'UserAccount'
  has_many :brand_accounts, class_name: 'Brand::Account', foreign_key: :brand_company_id
  has_many :brand_members, through: :brand_accounts, class_name: 'Brand::Member'
  has_many :user_accounts, through: :brand_members
  validates :siren_number, :label, presence: true

  validate :ape_code_accepted

  private

  def ape_code_accepted
    unless AUTHORIZED_REALTOR_CODES.include?(label) || AUTHORIZED_NOTARY_CODES.include?(label)
      errors.add(:ape_code, "APE CODE NOT AUTHORIZED.")
    end
  end
end
