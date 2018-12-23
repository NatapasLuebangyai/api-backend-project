class Api::TransactionsController < Api::BaseController
  include Cacheable

  def index
    transactions = current_user.transactions
    render json: transactions.map(&:display_informations), status: 200
  end

  def buy
    asset = cache_query(Asset, name: asset_params[:asset_name])
    if asset.blank?
      render json: { errors: t('transaction.buy.asset_name_invalid') }, status: :bad_request
      return false
    end

    transaction = Transaction::Buy.new(user: current_user, asset: asset)
    if transaction.save
      render json: transaction.display_informations, status: :created
    else
      render json: { errors: transaction.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def sell
    asset = cache_query(Asset, name: asset_params[:asset_name])
    if asset.blank?
      render json: { errors: t('transaction.sell.asset_name_invalid') }, status: :bad_request
      return false
    end

    transaction = Transaction::Sell.new(user: current_user, asset: asset)
    if transaction.save
      render json: transaction.display_informations, status: :created
    else
      render json: { errors: transaction.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def top_up
    begin
      money = formalize_money
    rescue => e
      render json: { errors: e }, status: :bad_request
      return false
    end

    transaction = Transaction::TopUp.new(user: current_user, amount: money)
    if transaction.save
      render json: transaction.display_informations, status: :created
    else
      render json: { errors: transaction.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def withdraw
    begin
      money = formalize_money
    rescue => e
      render json: { errors: e }, status: :bad_request
      return false
    end

    transaction = Transaction::Withdraw.new(user: current_user, amount: money)
    if transaction.save
      render json: transaction.display_informations, status: :created
    else
      render json: { errors: transaction.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def money_params
    params.permit(:amount, :currency)
  end

  def asset_params
    params.permit(:asset_name)
  end

  def formalize_money
    money = Money.from_amount(money_params[:amount].to_i, money_params[:currency])
    money = money.exchange_to(Money.default_currency) if money.currency != Money.default_currency
    money
  end
end
