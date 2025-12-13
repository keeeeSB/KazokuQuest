class FamiliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family, only: %i[show edit update]

  def show
  end

  def new
    @family = Family.new
  end

  def edit
  end

  def create
    ActiveRecord::Base.transaction do
      @family = Family.create!(family_params)
      current_user.update!(family: @family)
    end
    redirect_to root_path, notice: '家族情報を登録しました。'
  end

  def update
    if @family.update(family_params)
      redirect_to family_path(@family), notice: '家族情報を更新しました。'
    else
      flash.now[:alert] = '家族情報を更新できませんでした。'
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_family
    @family = current_user.family
  end

  def family_params
    params.expect(family: %i[name])
  end
end
