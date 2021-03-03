# frozen_string_literal: true

RSpec.shared_context 'auth0', shared_context: :metadata do
  let(:user_account_fail) { build_stubbed(:user_account, auth0_uid: auth_created_user_failed['user_id']) }
  let(:user_account_success) { create(:user_account, auth0_uid: auth_created_user['user_id']) }

  let(:auth_created_user) do
    {
        "created_at" => "2021-02-17T00:41:54.683Z",
        "email" => @user_email,
        "email_verified" => true,
        "identities" => [
            {
                "connection" => "Username-Password-Authentication",
                "user_id" => "602c6652c0520d006fcc20bf",
                "provider" => "auth0",
                "isSocial" => false
            }
        ],
        "name" => "xyz+3322@notiplus.com",
        "nickname" => "xyz+3322",
        "user_id" => "auth0|602c6652c0520d006fcc20bf"
    }
  end

  let(:auth_created_user_failed) do
    {
        "created_at" => "2021-02-17T00:41:54.683Z",
        "email" => @user_email,
        "email_verified" => true,
        "identities" => [
            {
                "connection" => "Username-Password-Authentication",
                "user_id" => "602c6652c0520d006fcc20bf",
                "provider" => "auth0",
                "isSocial" => false
            }
        ],
        "name" => "xyz+3322@notiplus.com",
        "nickname" => "xyz+3322",
        "user_id" => ''
    }
  end
end
