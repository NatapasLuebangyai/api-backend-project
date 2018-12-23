require 'rails_helper'

RSpec.describe Api::TransactionsController, type: :controller do
  let(:user)                { FactoryBot.create(:user) }
  let(:balance)             { user.balance }

  describe 'GET' do
    describe '#index'do
      let(:transactions)        { (1..5).map { |i| FactoryBot.build(:transaction_basis, user: user) } }

      before do
        user.transactions << transactions
      end

      it 'should return current user transactions display informations' do
        api_sign_in(user) do
          get :index
        end

        expect(response.status).to eq(200)
        expect(response.body).to eq(transactions.map(&:display_informations).to_json)
      end

      it 'should return status 401 if no authentication' do
        get :index
        expect(response.status).to eq(401)
      end
    end
  end

  describe 'POST' do
    describe '#buy' do
      let!(:asset)              { FactoryBot.create(:asset, price: 10) }

      before do
        balance.update(cash: 100)
      end

      it 'should create new buy transaction' do
        api_sign_in(user) do
          post :buy, params: {
            asset_name: asset.name
          }, format: :json
        end

        user.reload
        expect(user.transactions.count).to eq(1)

        transaction = user.transactions.last
        expect(transaction.class).to eq(Transaction::Buy)
        expect(transaction.asset).to eq(asset)

        expect(response.status).to eq(201)
        expect(response.body).to eq(transaction.display_informations.to_json)
      end

      it 'should render status 400 if wrong params asset_name' do
        api_sign_in(user) do
          post :buy, params: {
            asset_name: 'wrong_asset_name'
          }, format: :json
        end

        user.reload
        expect(user.transactions).not_to be_present
        expect(response.status).to eq(400)
      end

      it 'should render status 422 if create transaction failure' do
        balance.update(cash: 0)

        api_sign_in(user) do
          post :buy, params: {
            asset_name: asset.name
          }, format: :json
        end

        user.reload
        expect(user.transactions).not_to be_present
        expect(response.status).to eq(422)
      end

      it 'should return status 401 if no authentication' do
        get :buy
        expect(response.status).to eq(401)
      end
    end

    describe '#sell' do
      let(:asset)               { FactoryBot.create(:asset, price: 10) }
      let!(:asset_balance)      { FactoryBot.create(:asset_balance, balance: balance, asset: asset, amount: 10) }

      it 'should create new sell transaction' do
        api_sign_in(user) do
          post :sell, params: {
            asset_name: asset.name
          }, format: :json
        end

        user.reload
        expect(user.transactions.count).to eq(1)

        transaction = user.transactions.last
        expect(transaction.class).to eq(Transaction::Sell)
        expect(transaction.asset).to eq(asset)

        expect(response.status).to eq(201)
        expect(response.body).to eq(transaction.display_informations.to_json)
      end

      it 'should render status 400 if wrong params asset_name' do
        api_sign_in(user) do
          post :sell, params: {
            asset_name: 'wrong_asset_name'
          }, format: :json
        end

        user.reload
        expect(user.transactions).not_to be_present
        expect(response.status).to eq(400)
      end

      it 'should render status 422 if create transaction failure' do
        asset_balance.update(amount: 0)

        api_sign_in(user) do
          post :sell, params: {
            asset_name: asset.name
          }, format: :json
        end

        user.reload
        expect(user.transactions).not_to be_present
        expect(response.status).to eq(422)
      end

      it 'should return status 401 if no authentication' do
        get :sell
        expect(response.status).to eq(401)
      end
    end

    describe '#top_up' do
      it 'should create new top up transaction' do
        api_sign_in(user) do
          post :top_up, params: {
            amount: 10
          }, format: :json
        end

        user.reload
        expect(user.transactions.count).to eq(1)

        transaction = user.transactions.last
        expect(transaction.class).to eq(Transaction::TopUp)
        expect(transaction.amount).to eq(Money.from_amount(10))

        expect(response.status).to eq(201)
        expect(response.body).to eq(transaction.display_informations.to_json)
      end

      it 'should convert currecy with exchange rate to default currency' do
        api_sign_in(user) do
          post :top_up, params: {
            amount: 10,
            currency: 'THB'
          }, format: :json
        end

        user.reload
        expect(user.transactions.count).to eq(1)

        transaction = user.transactions.last
        expect(transaction.class).to eq(Transaction::TopUp)
        expect(transaction.amount).to eq(Money.from_amount(10, 'THB').exchange_to(Money.default_currency))

        expect(response.status).to eq(201)
        expect(response.body).to eq(transaction.display_informations.to_json)
      end

      it 'should render status 400 if wrong params currency' do
        api_sign_in(user) do
          post :top_up, params: {
            amount: 10,
            currency: 'AAA'
          }, format: :json
        end

        user.reload
        expect(user.transactions).not_to be_present
        expect(response.status).to eq(400)
      end

      it 'should render status 422 if create transaction failure' do
        api_sign_in(user) do
          post :top_up, params: {
            amount: -10
          }, format: :json
        end

        user.reload
        expect(user.transactions).not_to be_present
        expect(response.status).to eq(422)
      end

      it 'should return status 401 if no authentication' do
        get :buy
        expect(response.status).to eq(401)
      end
    end

    describe '#withdraw' do
      before do
        balance.update(cash: 10)
      end

      it 'should create new withdraw transaction' do
        api_sign_in(user) do
          post :withdraw, params: {
            amount: 10
          }, format: :json
        end

        user.reload
        expect(user.transactions.count).to eq(1)

        transaction = user.transactions.last
        expect(transaction.class).to eq(Transaction::Withdraw)
        expect(transaction.amount).to eq(Money.from_amount(10))

        expect(response.status).to eq(201)
        expect(response.body).to eq(transaction.display_informations.to_json)
      end

      it 'should convert currecy with exchange rate to default currency' do
        api_sign_in(user) do
          post :withdraw, params: {
            amount: 10,
            currency: 'THB'
          }, format: :json
        end

        user.reload
        expect(user.transactions.count).to eq(1)

        transaction = user.transactions.last
        expect(transaction.class).to eq(Transaction::Withdraw)
        expect(transaction.amount).to eq(Money.from_amount(10, 'THB').exchange_to(Money.default_currency))

        expect(response.status).to eq(201)
        expect(response.body).to eq(transaction.display_informations.to_json)
      end

      it 'should render status 400 if wrong params currency' do
        api_sign_in(user) do
          post :withdraw, params: {
            amount: 10,
            currency: 'AAA'
          }, format: :json
        end

        user.reload
        expect(user.transactions).not_to be_present
        expect(response.status).to eq(400)
      end

      it 'should render status 422 if create transaction failure' do
        api_sign_in(user) do
          post :withdraw, params: {
            amount: -1
          }, format: :json
        end

        user.reload
        expect(user.transactions).not_to be_present
        expect(response.status).to eq(422)
      end

      it 'should return status 401 if no authentication' do
        get :buy
        expect(response.status).to eq(401)
      end
    end
  end
end
