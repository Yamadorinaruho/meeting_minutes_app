class EmployeesController < ApplicationController
  before_action :require_admin!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  def index
    @employees = current_company.employees.includes(:department).order(:employee_number)
  end

  def show
    @meeting_minutes = @employee.meeting_minutes.order(meeting_date: :desc)
  end

  def new
    @employee = current_company.employees.build
  end

  def create
    @employee = current_company.employees.build(employee_params)

    if @employee.save
      redirect_to @employee, notice: "従業員を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @employee.update(employee_params)
      redirect_to @employee, notice: "従業員を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @employee.destroy
      redirect_to employees_path, notice: "従業員を削除しました"
    else
      redirect_to @employee, alert: "削除できませんでした"
    end
  end

  private

  def set_employee
    @employee = current_company.employees.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:employee_number, :name, :email, :department_id, :status, :retired_at, :admin)
  end
end
