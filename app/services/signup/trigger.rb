module Signup
  class Trigger < ApplicationService
    attr_reader :user_account, :brand_company

    def initialize(params)
      @email = params[:email]
      @first_name = params[:first_name]
      @last_name = params[:last_name]
      @phone_number = params[:phone_number]
      @siret = params[:siret]
    end

    def process
      user
      company
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

    def company
      @brand_company = Brand::Company.create(
          owner_id: user_account.id,
          siren_number: @siret[0..8],
          label: ape_code
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
