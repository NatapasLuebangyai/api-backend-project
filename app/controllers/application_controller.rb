class ApplicationController < ActionController::Base
  def render_forbidden
    render file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false
  end

  def render_not_found
    render file: File.join(Rails.root, 'public/404.html'), status: 404, layout: false
  end
end
