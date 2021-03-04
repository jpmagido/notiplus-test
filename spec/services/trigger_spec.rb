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

        expect(subject.user_account.errors.messages[:auth0_uid]).to be_empty
        expect(subject.user_account).to be_valid
      end
    end
  end

  context 'Create Brand::Company' do
    describe 'accepted APE' do
      before do
        allow(Siret::Lookup).to receive(:process).and_return(siret_lookup_response)
        allow(Auth0::User::Create).to receive(:new).with(initial_params[:email], nil).and_return(auth_created_user)
      end

      it 'should create a valid company' do
        subject.process

        expect(subject.brand_company.errors.messages).to be_empty
        expect(subject.brand_company).to be_valid
      end

      it 'should be related to user_account' do
        subject.process
        expect(subject.brand_company.owner_id).to eq subject.user_account.id
      end
    end

    describe 'denied APE' do
      it 'should return errors' do
        allow(Auth0::User::Create).to receive(:new).with(initial_params[:email], nil).and_return(auth_created_user)
        allow(Siret::Lookup).to receive(:process).and_return(siret_lookup_response_failed)

        subject.process

        expect(subject.brand_company.errors.messages[:ape_code]).to eq ["APE CODE NOT AUTHORIZED."]
      end
    end
  end

end
