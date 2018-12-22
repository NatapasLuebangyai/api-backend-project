class Api::BalancesController < Api::BaseController

  def index
    render json: current_user.balance, status: :ok
  end
end
