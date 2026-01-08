class BadgeRuleEvaluator
  def self.call(badge, work_count:, total_points:, counts_by_category:, points_by_category:)
    case badge.rule_type
    when 'task_count'
      task_count?(badge, work_count, counts_by_category)
    when 'total_points'
      total_points?(badge, total_points, points_by_category)
    else
      false
    end
  end

  def self.task_count?(badge, work_count, counts_by_category)
    if badge.rule_category.present?
      counts_by_category[badge.rule_category.to_s].to_i == badge.rule_value
    else
      work_count == badge.rule_value
    end
  end

  def self.total_points?(badge, total_points, points_by_category)
    if badge.rule_category.present?
      points_by_category[badge.rule_category.to_s].to_i >= badge.rule_value
    else
      total_points >= badge.rule_value
    end
  end
end
