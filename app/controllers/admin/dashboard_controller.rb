class Admin::DashboardController < ApplicationController
  before_action :require_admin!

  def index
    @departments = current_company.departments
    @employees = current_company.employees.includes(:department, :position).active

    # フィルター
    @selected_department_id = params[:department_id]
    @selected_employee_id = params[:employee_id]

    # 対象の議事録を取得
    @meeting_minutes = current_company.meeting_minutes
                                      .includes(:employee, :shared_employees)
                                      .where.not(start_time: nil, end_time: nil)

    # 部署フィルター
    if @selected_department_id.present?
      employee_ids = current_company.employees.where(department_id: @selected_department_id).pluck(:id)
      @meeting_minutes = @meeting_minutes.where(employee_id: employee_ids)
    end

    # 従業員フィルター
    if @selected_employee_id.present?
      @meeting_minutes = @meeting_minutes.where(employee_id: @selected_employee_id)
    end

    # 集計
    calculate_stats
  end

  private

  def calculate_stats
    @total_meetings = @meeting_minutes.count
    @total_duration_minutes = @meeting_minutes.sum { |m| m.duration_minutes }
    @total_cost = @meeting_minutes.sum { |m| m.estimated_cost }

    # 時間を時間と分に分解
    @total_hours = @total_duration_minutes / 60
    @total_minutes = @total_duration_minutes % 60

    # 部署別集計
    @department_stats = calculate_department_stats

    # 従業員別集計
    @employee_stats = calculate_employee_stats
  end

  def calculate_department_stats
    stats = {}
    current_company.departments.each do |dept|
      employee_ids = dept.employees.pluck(:id)
      dept_minutes = current_company.meeting_minutes
                                    .where(employee_id: employee_ids)
                                    .where.not(start_time: nil, end_time: nil)

      minutes_sum = dept_minutes.sum { |m| m.duration_minutes }
      cost_sum = dept_minutes.sum { |m| m.estimated_cost }

      stats[dept.id] = {
        name: dept.name,
        meeting_count: dept_minutes.count,
        duration_minutes: minutes_sum,
        cost: cost_sum
      }
    end
    stats
  end

  def calculate_employee_stats
    stats = {}
    target_employees = if @selected_department_id.present?
      current_company.employees.where(department_id: @selected_department_id)
    else
      current_company.employees
    end

    target_employees.includes(:position, :department).each do |emp|
      emp_minutes = emp.meeting_minutes.where.not(start_time: nil, end_time: nil)

      minutes_sum = emp_minutes.sum { |m| m.duration_minutes }
      cost_sum = emp_minutes.sum { |m| m.estimated_cost }

      stats[emp.id] = {
        name: emp.name,
        department: emp.department&.name,
        position: emp.position&.name,
        hourly_rate: emp.hourly_rate,
        meeting_count: emp_minutes.count,
        duration_minutes: minutes_sum,
        cost: cost_sum
      }
    end
    stats.sort_by { |_, v| -v[:cost] }.to_h
  end
end
