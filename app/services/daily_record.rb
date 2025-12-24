class DailyRecord
  attr_reader :user, :date

  def initialize(user, date)
    @user = user
    @date = date
  end

  def works
    @works ||= user.works.where(done_on: date)
  end

  def total_point
    works.sum { |work| work.task.point }
  end
end
