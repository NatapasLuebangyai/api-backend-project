class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    authenticate_user!
    render_forbidden and return false unless current_user.admin
  end
end
