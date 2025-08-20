class QuestsController < ApplicationController
  before_action :set_quest, only: %i[ destroy toggle_done ]

  def index
    @quests = Quest.all
  end

def create
  @quest = Quest.new(quest_params)
  if @quest.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to quests_path, notice: "Quest created." }
    end
  else
    respond_to do |format|
      format.turbo_stream
      format.html { render partial: "quests/form", locals: { quest: @quest }, status: :unprocessable_entity }
    end
  end
end

  def destroy
    @quest.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to quests_url, notice: "Quest was successfully destroyed." }
    end
  end

  def toggle_done
    @quest.update(is_done: !@quest.is_done)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to quests_path }
    end
  end

  private

    def set_quest
      @quest = Quest.find(params[:id])
    end

    def quest_params
      params.require(:quest).permit(:description, :is_done)
    end
end
