require 'rails_helper'

RSpec.describe Signup::Trigger, type: :service do
  let!(:initial_params) { {
      email: "user@rspec.com", # required
      password: "azerty", # required
      phone_number: "0666666666", # optional
      first_name: "bot", # optional
      last_name: "san", # optional
      siret: "0000000000099" # required
  } }

  subject { described_class.new(initial_params) }

  before { @user_email = initial_params[:email] }

  include_context 'auth0'
  include_context 'actions'

  context 'User::Account creation' do
    before { allow(Siret::Lookup).to receive(:process).and_return(siret_lookup_response) }

    describe 'failed auth' do
      it 'should create a valid User::Account model instance' do
        allow(Auth0::User::Create).to receive(:new).with(initial_params[:email], nil).and_return(auth_created_user_failed)

        subject.process

        expect(subject.user_account.errors.messages[:auth0_uid]).to eq ["can't be blank"]
      end
    end

    describe 'success auth' do
      it 'should create a valid User::Account model instance' do
        allow(Auth0::User::Create).to receive(:new).with(initial_params[:email], nil).and_return(auth_created_user)

        subject.process

        expect(subject.user_account).to be_valid
      end
    end
  end

  context 'Create Brand::Objects' do
    before do
      allow(Auth0::User::Create).to receive(:new).with(initial_params[:email], nil).and_return(auth_created_user)
    end

    describe 'Brand::Company with accepted APE' do
      before do
        allow(Siret::Lookup).to receive(:process).and_return(siret_lookup_response)
        subject.process
      end

      it 'should create a valid company' do
        expect(subject.brand_company).to be_valid
      end

      it 'should be related to user_account' do
        expect(subject.brand_company.owner_id).to eq subject.user_account.id
      end
    end

    describe 'Brand::Company with denied APE' do
      it 'should return errors' do
        allow(Siret::Lookup).to receive(:process).and_return(siret_lookup_response_failed)

        subject.process

        expect(subject.brand_company.errors.messages[:ape_code]).to eq ["APE CODE NOT AUTHORIZED."]
      end
    end

    describe 'Create Brand::Account & Brand::Member' do
      before do
        allow(Siret::Lookup).to receive(:process).and_return(siret_lookup_response)
        subject.process
      end

      it 'should create a valid instance of Brand::Company' do
        expect(subject.brand_account).to be_valid
      end

      it 'Brand::Account should have same label as Brand::Company' do
        expect(subject.brand_account.label).to eq subject.brand_company.label
      end

      it 'Brand::Account should have same siret_number as Brand::Company' do
        expect(subject.brand_account.siret_number).to eq initial_params[:siret]
      end

      it 'should create a valid instance of Brand::Member' do
        expect(subject.brand_member).to be_valid
      end

      it 'should create a valid instance of Brand::Member with proper relations' do
        expect(subject.brand_member.user_account_id).to eq subject.user_account.id
      end
    end
  end
end
