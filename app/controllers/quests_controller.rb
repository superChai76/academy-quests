class QuestsController < ApplicationController
  before_action :set_quest, only: %i[ destroy toggle_done ]

  # GET /quests or /quests.json
  def index
    @quests = Quest.all
  end

  # GET /quests/new
  def new
    @quest = Quest.new
  end

  # POST /quests or /quests.json
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
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quests/1 or /quests/1.json
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
    # Use callbacks to share common setup or constraints between actions.
    def set_quest
      @quest = Quest.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def quest_params
      params.expect(quest: [ :description, :is_done ])
    end
end
