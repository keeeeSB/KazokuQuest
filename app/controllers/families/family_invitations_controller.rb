class Families::FamilyInvitationsController < Families::ApplicationController
  def new
    @family_invitation = @family.family_invitations.build
  end

  def create
    @family_invitation = @family.family_invitations.build(family_invitation_params)
    if @family_invitation.save
      FamilyInvitationMailer.invite(@family_invitation).deliver_now
      redirect_to family_path, notice: '家族招待メールを送信しました。'
    else
      flash.now[:alert] = '家族招待メールを送信できませんでした。'
      render :new, status: :unprocessable_content
    end
  end

  private

  def family_invitation_params
    params.expect(family_invitation: %i[email])
  end
end
