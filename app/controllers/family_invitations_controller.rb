class FamilyInvitationsController < ApplicationController
  def accept
    invitation = FamilyInvitation.find_by(token: params[:token])

    if invitation.nil? || invitation.expires_at < Time.current
      redirect_to root_path, alert: '無効なリンクです。'
    end

    if user_signed_in?
      ActiveRecord::Base.transaction do
        current_user.update!(family: invitation.family)
        invitation.destroy!
      end
      redirect_to family_path, notice: '家族情報を登録しました。'
    else
      session[:family_invitation_token] = invitation.token
      redirect_to new_user_registration_path, notice: 'ユーザー登録を行なってください。'
    end
  end
end
