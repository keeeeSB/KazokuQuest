class Families::ApplicationController < ApplicationController
  before_action :authenticate_user!

  private

  def set_family
    @family = current_user.family
  end
end
