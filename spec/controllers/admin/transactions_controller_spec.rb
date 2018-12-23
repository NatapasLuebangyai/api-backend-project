require 'rails_helper'

RSpec.describe Admin::TransactionsController, type: :controller do
  let!(:admin)               { FactoryBot.create(:user, admin: true) }
  let!(:user)                { FactoryBot.create(:user) }

  describe 'GET' do
    describe '#index'do
      it 'should response with status 200' do
        sign_in_as(admin) do
          get :index
        end
        expect(response.status).to eq(200)
      end

      it 'should response with status 403 if not authenticate as admin' do
        sign_in_as(user) do
          get :index
        end
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'POST' do
    let!(:transaction)         { FactoryBot.create(:transaction_basis, user: user) }

    describe '#approve'do
      it 'should approve transaction' do
        sign_in_as(admin) do
          post :approve, params: {
            id: transaction.id
          }
        end

        transaction.reload
        expect(transaction.approved).to eq(true)
        expect(response.status).to eq(302)
      end

      it 'should response with status 403 if not authenticate as admin' do
        sign_in_as(user) do
          post :approve, params: {
            id: transaction.id
          }
        end
        expect(response.status).to eq(403)
      end
    end

    describe '#reject'do
      it 'should reject transaction' do
        sign_in_as(admin) do
          post :reject, params: {
            id: transaction.id
          }
        end

        transaction.reload
        expect(transaction.approved).to eq(false)
        expect(response.status).to eq(302)
      end

      it 'should response with status 403 if not authenticate as admin' do
        sign_in_as(user) do
          post :reject, params: {
            id: transaction.id
          }
        end
        expect(response.status).to eq(403)
      end
    end
  end

end
