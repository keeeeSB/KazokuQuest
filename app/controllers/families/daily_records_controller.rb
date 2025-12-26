class Families::DailyRecordsController < ApplicationController
  before_action :authenticate_user!

  def show
    date = Date.current
    family = current_user.family
    @daily_records = family.users.map do |user|
      DailyRecord.new(user, date)
    end
  end
end
