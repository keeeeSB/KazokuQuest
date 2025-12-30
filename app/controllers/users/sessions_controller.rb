class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      flash[:notice] = if resource.family_id.present?
                         'ログインしました。'
                       else
                         '家族情報を登録してください。'
                       end
    end
  end

  protected

  def after_sign_in_path_for(resource)
    if (token = session.delete(:family_invitation_token))
      invitation = FamilyInvitation.find_by(token:)

      if invitation&.expires_at&.future?
        resource.update!(family: invitation.family)
        invitation.destroy!
        flash[:notice] = '家族情報を登録しました。'
        return family_path
      end
    end

    resource.family_id.present? ? root_path : new_family_path
  end
end
