class AgendaMailer < ApplicationMailer
  def agenda_mail(agenda)
    @agenda = agenda

    mail to: @agenda.email, subject: "アジェンダ削除の確認メール"
  end
end