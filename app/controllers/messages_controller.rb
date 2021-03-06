class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
    #if there is a user logged in
    if current_user != nil
      #only load all of the chat messages since the user last logged in
      @messages = Message.where("updated_at >= ?", current_user.updated_at)
    end
    render json: @messages.to_json(except: [:id, :created_at, :updated_at, :user_id], include: {:user => {:only => :name}})
  end

  def download
    @messages = Message.all
    #if there is a user logged in
    if current_user != nil
      #only load all of the chat messages since the user last logged in
      @messages = Message.where("updated_at >= ?", current_user.updated_at)
    end


    respond_to do |format|
      format.text { send_data @messages.to_json(except: [:id, :created_at, :updated_at, :user_id], include: {:user => {:only => :name}}),type: :json, disposition: "attachment" }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show

  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
    @message.user_id=current_user.id

    respond_to do |format|
      if @message.save
        format.js { render nothing: true }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      @message.user_id=current_user.id
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:message, :user_id)
    end
end
