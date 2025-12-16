class Admins::TasksController < Admins::ApplicationController
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.default_order.page(params[:page])
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to admins_task_path(@task), notice: 'タスクを作成しました。'
    else
      flash.now[:alert] = 'タスクを作成できませんでした。'
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to admins_task_path(@task), notice: 'タスクを更新しました。'
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @task.destroy!
    redirect_to admins_tasks_path, notice: 'タスクを削除しました。', status: :see_other
  end

  private

  def task_params
    params.expect(task: %i[name category point])
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
