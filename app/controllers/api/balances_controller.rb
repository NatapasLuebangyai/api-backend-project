class Api::BalancesController < Api::BaseController

  def index
    render json: current_user.balance.display_informations, status: :ok
  end
end
