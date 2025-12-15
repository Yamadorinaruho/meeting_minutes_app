class DashboardController < ApplicationController
  def index
    # 自分が作成した議事録 + 共有されている議事録
    owned_ids = current_employee.meeting_minutes.pluck(:id)
    shared_ids = current_employee.shared_meeting_minutes.pluck(:id)
    accessible_ids = (owned_ids + shared_ids).uniq

    @recent_meeting_minutes = current_company.meeting_minutes
                                             .where(id: accessible_ids)
                                             .includes(:employee)
                                             .order(meeting_date: :desc)
                                             .limit(5)
    @employees_count = current_company.employees.active.count
    @my_meeting_minutes_count = accessible_ids.size
  end
end
