class BadgeGranter
  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    Badge.active.each do |badge|
      next if @user.badges.exists?(badge_id: badge.id)
      next unless BadgeRuleEvaluator.call(@user, badge)

      grant_badge(badge)
    end
  end

  private

  def grant_badge(badge)
    @user.user_badges.create!(badge:, awarded_at: Time.current)
  end
end
