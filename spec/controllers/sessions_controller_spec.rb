require "rails_helper"

RSpec.describe SessionsController, type: :controller do

  let!(:provider) { 'square' }
  let!(:uid) { '12345' }
  let!(:token) { '123123123' }
  let!(:square_mock) { OmniAuth::AuthHash.new(provider: provider, uid: uid, credentials: {token: token}) }

  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:square] = square_mock
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:square] 
  end

  let!(:user) {create(:user)}

  context "omniauth sessions" do

    describe "POST /auth/:provider/callback" do
      subject{ post :create, provider: provider }

      it "creates user" do
        expect(subject).to redirect_to root_path
        expect(assigns(:user)).to be_an_instance_of(User)
        expect(assigns(:user).uid).to eq uid
      end

      it "ignores not uniq credentials" do
        expect{
          post :create, provider: provider
        }.to_not raise_error
        expect(assigns(:user)).to be_an_instance_of(User)
        expect(assigns(:user).token).to eq token
      end
    end

    describe "GET /auth/failure" do
      subject { get :failure }

      it "redirects" do
        expect(subject).to redirect_to root_path
      end
    end

  end
end