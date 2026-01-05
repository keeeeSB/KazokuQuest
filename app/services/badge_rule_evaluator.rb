class BadgeRuleEvaluator
  def self.call(user, badge)
    new(user, badge).call
  end

  def initialize(user, badge)
    @user = user
    @badge = badge
  end

  def call
    case @badge.rule_type
    when 'total_points'
      total_points_rule?
    when 'first_task'
      first_task_rule?
    else
      false
    end
  end

  private

  def total_points_rule?
    @user.works.sum(:point) >= @badge.rule_value
  end

  def first_task_rule?
    @user.works.count == 1
  end
end
