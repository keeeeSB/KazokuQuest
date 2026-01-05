class Users::WorksController < Users::ApplicationController
  before_action :set_work, only: %i[show edit update destroy]

  def show
  end

  def new
    @work = current_user.works.build
  end

  def edit
  end

  def create
    @work = current_user.works.build(work_params)
    if @work.save
      BadgeGranter.call(current_user)
      redirect_to users_work_path(@work), notice: '作業を記録しました。'
    else
      flash.now[:alert] = '作業を記録できませんでした。'
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @work.update(work_params)
      redirect_to users_work_path(@work), notice: '作業内容を更新しました。'
    else
      flash.now[:alert] = '作業内容を更新できませんでした。'
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @work.destroy!
    redirect_to root_path, notice: '作業を削除しました。', status: :see_other
  end

  private

  def work_params
    params.expect(work: %i[task_id done_on memo])
  end

  def set_work
    @work = current_user.works.find(params[:id])
  end
end
