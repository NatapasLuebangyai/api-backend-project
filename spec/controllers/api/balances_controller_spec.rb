require 'rails_helper'

RSpec.describe Api::BalancesController, type: :controller do
  let(:user)                { FactoryBot.create(:user) }
  let(:balance)             { user.balance }

  describe 'GET' do
    describe '#index' do
      it 'should return current user balance display informations' do
        api_sign_in(user) do
          get :index
        end

        expect(response.status).to eq(200)
        expect(response.body).to eq(balance.display_informations.to_json)
      end

      it 'should render status 401 if no authentication' do
        get :index
        expect(response.status).to eq(401)
      end
    end
  end
end
