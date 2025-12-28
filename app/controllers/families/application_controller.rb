class Families::ApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family

  private

  def set_family
    @family = current_user.family
  end
end
