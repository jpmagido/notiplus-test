module Signup
  class Trigger < ApplicationService
    attr_reader :user_account, :brand_company, :brand_account, :brand_member

    def initialize(params)
      @email = params[:email]
      @first_name = params[:first_name]
      @last_name = params[:last_name]
      @phone_number = params[:phone_number]
      @siret = params[:siret]
    end

    def process
      user
      brand
    end

    private

    def user
      @user_account = UserAccount.create(
          email: @email,
          first_name: @first_name,
          last_name: @last_name,
          phone_number: @phone_number,
          auth0_uid: auth0_user_id
      )
    end

    def brand
      create_company
      create_account
      create_membership
    end

    def create_company
      @brand_company = Brand::Company.create(
          owner_id: user_account.id,
          siren_number: @siret[0..8],
          label: ape_code
      )
    end

    def create_account
      @brand_account = Brand::Account.create(
          brand_company_id: brand_company.id,
          label: brand_company.label,
          siret_number: @siret
      )
    end

    def create_membership
      @brand_member = Brand::Member.create(
          brand_account_id: brand_account.id,
          user_account_id: user_account.id
      )
    end

    def ape_code
      siret_lookup[:uniteLegale][:periodesUniteLegale][0][:activitePrincipaleUniteLegale]
    end

    def siret_lookup
      @siret_lookup ||= ::Siret::Lookup.process
    end

    def auth0_user_id
      @auth0_user ||= Auth0::User::Create.new(@email, @password)['user_id']
    end
  end
end
