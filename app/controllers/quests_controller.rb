class QuestsController < ApplicationController
  before_action :set_quest, only: %i[ destroy toggle_done ]

  def index
    @quest  = Quest.new
    @quests = Quest.order(:is_done, :created_at)
  end

  def create
    @quest = Quest.new(quest_params)

 if @quest.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to quests_path, notice: "Quest created" }
    end
    else
      respond_to do |format|
        # Turbo: แทนที่ฟอร์มด้วย error state
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "new_quest_form",
            partial: "quests/form",
            locals: { quest: @quest }
          )
        end

        # HTML: ต้องเตรียมตัวแปรให้ view index ใช้
        format.html do
          @quests = Quest.order(:is_done, :created_at)
          render :index, status: :unprocessable_content  # (422)
        end
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
