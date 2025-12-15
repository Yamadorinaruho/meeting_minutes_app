class MeetingMinutesController < ApplicationController
  before_action :set_meeting_minute, only: [:show, :edit, :update, :destroy]
  before_action :authorize_access!, only: [:show]
  before_action :authorize_edit!, only: [:edit, :update, :destroy]

  def index
    # 自分が作成した議事録 + 共有されている議事録
    owned_ids = current_employee.meeting_minutes.pluck(:id)
    shared_ids = current_employee.shared_meeting_minutes.pluck(:id)
    accessible_ids = (owned_ids + shared_ids).uniq

    @meeting_minutes = current_company.meeting_minutes
                                      .where(id: accessible_ids)
                                      .includes(:employee, :shared_employees)
                                      .order(start_time: :desc)
  end

  def show
    @employees = current_company.employees.active.where.not(id: @meeting_minute.employee_id)
  end

  def new
    @meeting_minute = current_company.meeting_minutes.build
    @employees = current_company.employees.active.where.not(id: current_employee.id)
  end

  def create
    @meeting_minute = current_company.meeting_minutes.build(meeting_minute_params)
    @meeting_minute.employee = current_employee

    if @meeting_minute.save
      update_shares
      redirect_to @meeting_minute, notice: "議事録を作成しました"
    else
      @employees = current_company.employees.active.where.not(id: current_employee.id)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @employees = current_company.employees.active.where.not(id: @meeting_minute.employee_id)
  end

  def update
    if @meeting_minute.update(meeting_minute_params)
      update_shares
      redirect_to @meeting_minute, notice: "議事録を更新しました"
    else
      @employees = current_company.employees.active.where.not(id: @meeting_minute.employee_id)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @meeting_minute.destroy
    redirect_to meeting_minutes_path, notice: "議事録を削除しました"
  end

  private

  def set_meeting_minute
    @meeting_minute = current_company.meeting_minutes.find(params[:id])
  end

  def authorize_access!
    unless @meeting_minute.accessible_by?(current_employee)
      redirect_to meeting_minutes_path, alert: "アクセス権限がありません"
    end
  end

  def authorize_edit!
    unless @meeting_minute.employee_id == current_employee.id
      redirect_to meeting_minutes_path, alert: "編集権限がありません"
    end
  end

  def meeting_minute_params
    params.require(:meeting_minute).permit(:title, :start_time, :end_time, :content)
  end

  def update_shares
    shared_employee_ids = params[:meeting_minute][:shared_employee_ids]&.reject(&:blank?) || []

    @meeting_minute.meeting_minute_shares.destroy_all
    shared_employee_ids.each do |employee_id|
      @meeting_minute.meeting_minute_shares.create(employee_id: employee_id)
    end
  end
end
