class Users::DailyRecordsController < Users::ApplicationController
  def show
    date = Date.current
    @daily_record = DailyRecord.new(current_user, date)
  end
end
