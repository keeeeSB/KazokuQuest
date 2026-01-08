class Admins::BadgesController < Admins::ApplicationController
  before_action :set_badge, only: %i[show edit update destroy]

  def index
    @badges = Badge.default_order.page(params[:page])
  end

  def show
  end

  def new
    @badge = Badge.new
  end

  def edit
  end

  def create
    @badge = Badge.new(badge_params)
    if @badge.save
      redirect_to admins_badge_path(@badge), notice: 'バッジを登録しました。'
    else
      flash.now[:alert] = 'バッジを登録できませんでした。'
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @badge.update(badge_params)
      redirect_to admins_badge_path(@badge), notice: 'バッジ情報を更新しました。'
    else
      flash.now[:alert] = 'バッジ情報を更新できませんでした。'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @badge.destroy!
    redirect_to admins_badges_path, notice: 'バッジを削除しました。', status: :see_other
  end

  private

  def badge_params
    params.expect(badge: %i[name description rule_type rule_category rule_value enabled])
  end

  def set_badge
    @badge = Badge.find(params[:id])
  end
end
