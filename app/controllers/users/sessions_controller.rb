class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if resource.family_id.present?
      set_flash_message!(:notice, :signed_in, message: 'ログインしました！')
      root_path
    else
      set_flash_message!(:notice, :signed_in, message: '家族情報を登録してください。')
      new_family_path
    end
  end
end
