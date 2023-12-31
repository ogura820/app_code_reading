class AgendasController < ApplicationController
  # before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end

  def destroy
    @agenda = Agenda.find(params[:id])
    if @agenda.user_id == current_user.id || @agenda.team.owner_id == current_user.id
      agenda_team= @agenda.team
      @agenda_members = agenda_team.members
      @agenda_members.each do |member|
        AgendaMailer.agenda_mail(member).deliver
      end
      @agenda.destroy
      redirect_to dashboard_path, notice:"アジェンダを削除しました！"
    else
      redirect_to dashboard_url, notice:"削除する権限がありません"
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
    redirect_to dashboard_path
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
