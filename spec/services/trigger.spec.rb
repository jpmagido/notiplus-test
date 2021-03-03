require 'rails_helper'

RSpec.describe Signup::Trigger, type: :service do
  describe 'UserAccount creation' do

    subject { Signup::Trigger.new({email: 'email_user@test.com', password: 'blablabla'})}
    it 'should create a valid user account' do
      mock = Auth0::User::Create.new('email_user@test.com', 'blablabla')

      subject.user
      expect(mock).to have_received(:process)
    end
  end
end
