require 'rails_helper'

RSpec.describe Api::BalancesController, type: :controller do
  let!(:user)               { FactoryBot.create(:user) }

  describe 'GET' do
    describe '#index' do
      it 'should return current user balance' do
        api_sign_in(user) do
          get :index
        end
        expect(response.status).to eq(200)
        expect(response.body).to eq(user.balance.to_json)
      end

      it 'should return http status 401 if not authenticate' do
        get :index
        expect(response.status).to eq(401)
      end
    end
  end
end
