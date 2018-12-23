class Admin::TransactionsController < Admin::BaseController
  before_action :get_transaction, only: [:approve, :reject]

  def index
    @top_up_transactions = Transaction::TopUp.where(approved: nil).all
    @withdraw_transactions = Transaction::Withdraw.where(approved: nil).all
  end

  def approve
    if @transaction.perform and @transaction.approve!
      flash[:success] = t('transaction.approve.success')
    else
      flash[:error] = @transaction.errors.full_messages.join(', ')
    end

    redirect_to admin_transactions_path
  end

  def reject
    if @transaction.reject!
      flash[:success] = t('transaction.reject.success')
    else
      flash[:error] = @transaction.errors.full_messages.join(', ')
    end

    redirect_to admin_transactions_path
  end

  private

  def get_transaction
    @transaction = Transaction::Base.find_by(id: params[:id])
  end
end
