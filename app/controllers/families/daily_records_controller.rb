class Families::DailyRecordsController < Families::ApplicationController
  def show
    date = Date.current
    @daily_records = @family.users.map do |user|
      DailyRecord.new(user, date)
    end
  end
end
