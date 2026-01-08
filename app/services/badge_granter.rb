class BadgeGranter
  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    works = @user.works.joins(:task)
    work_count = works.count
    counts_by_category = works.group('tasks.category').count
    points_by_category = works.group('tasks.category').sum('tasks.point')
    total_points = points_by_category.values.sum
    owned_badge_ids = @user.user_badges.pluck(:badge_id)

    Badge.active.each do |badge|
      next if owned_badge_ids.include?(badge.id)
      next unless BadgeRuleEvaluator.call(
        badge,
        work_count:,
        total_points:,
        counts_by_category:,
        points_by_category:
      )

      grant_badge(badge)
    end
  end

  private

  def grant_badge(badge)
    @user.user_badges.create!(badge:, awarded_at: Time.current)
  end
end
