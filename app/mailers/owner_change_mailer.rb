class Owner_changeMailer < ApplicationMailer
  def owner_change_mail(owner_change)
    @owner_change = owner_change

    mail to: @owner_change.email, subject: "オーナー権限変更の確認メール"
  end
end
