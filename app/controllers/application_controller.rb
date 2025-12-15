class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!

  helper_method :current_company, :current_employee, :admin?

  private

  def current_company
    current_user&.company
  end

  def current_employee
    current_user&.employee
  end

  def admin?
    current_employee&.admin?
  end

  def require_admin!
    unless admin?
      redirect_to root_path, alert: "管理者権限が必要です"
    end
  end
end
