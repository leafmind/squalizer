require "rails_helper"

RSpec.describe UsersController, type: :controller do

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  let!(:user) {create(:user)}

  context "sandbox users" do

    describe "GET /users" do
      it "shows all users" do
        get :index
        expect(assigns(:users)).not_to be_empty
        expect(assigns(:sandbox_users)).not_to be_empty
      end
    end

    describe "GET /users/:id" do
      it "shows specified user" do
        get :show, id: user.id
        expect(assigns(:user)).to be_an_instance_of(User)
        expect(assigns(:locations)).to be_empty
      end
    end

    describe "PUT /users/:id" do
      it "updates user" do
        expect {
          put :update, id: user.id, user: {state: :fetch}
        }.to enqueue_job(FetchDataJob)
        expect(assigns(:user)).to be_an_instance_of(User)
      end
    end

    describe "users in ready state" do
      it "shows users" do
        messages = create_list(:user, 10, state: :ready)
        get :index
        expect(assigns(:sandbox_users)).not_to be_empty
      end
    end

  end
end