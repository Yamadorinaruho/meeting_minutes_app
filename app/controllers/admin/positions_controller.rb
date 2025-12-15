class Admin::PositionsController < ApplicationController
  before_action :require_admin!
  before_action :set_position, only: [:edit, :update, :destroy]

  def index
    @positions = current_company.positions.order(:rank)
  end

  def new
    @position = current_company.positions.build
  end

  def create
    @position = current_company.positions.build(position_params)

    if @position.save
      redirect_to admin_positions_path, notice: "役職を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @position.update(position_params)
      redirect_to admin_positions_path, notice: "役職を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @position.employees.any?
      redirect_to admin_positions_path, alert: "この役職に所属する従業員がいるため削除できません"
    else
      @position.destroy
      redirect_to admin_positions_path, notice: "役職を削除しました"
    end
  end

  private

  def set_position
    @position = current_company.positions.find(params[:id])
  end

  def position_params
    params.require(:position).permit(:name, :hourly_rate, :rank)
  end
end
