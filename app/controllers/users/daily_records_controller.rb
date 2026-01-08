class Users::DailyRecordsController < Users::ApplicationController
  def show
    date = daily_record_params[:date]&.to_date || Date.current
    @daily_record = DailyRecord.new(current_user, date)
  end

  private

  def daily_record_params
    params.fetch(:daily_record, {}).permit(:date)
  end
end
