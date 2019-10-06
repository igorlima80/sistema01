module Admin
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    before_action :authenticate_user!
    before_action :set_configurations

    rescue_from CanCan::AccessDenied do |exception|
      flash[:danger] = 'Você não está autorizado a fazer essa ação!'
      Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
      respond_to do |format|
        format.json { head :forbidden, content_type: 'text/html' }
        format.html { redirect_to main_app.root_url }
        format.js   { head :forbidden, content_type: 'text/html' }
      end
    end

    private
    def set_configurations
      @app_name = "Sistema 01"
      @sidebar_menus = MenuItem.sidebar.root
    end
  end
end
