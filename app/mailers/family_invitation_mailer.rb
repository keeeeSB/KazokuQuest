class FamilyInvitationMailer < ApplicationMailer
  def invite(family_invitation)
    @family_invitation = family_invitation
    @family = family_invitation.family
    @invite_url = accept_family_invitations_url(token: family_invitation.token)

    mail to: family_invitation.email, subject: '【KazokuQuest】家族招待のお知らせ'
  end
end
