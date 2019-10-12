class ChatsController < ApplicationController
  layout 'application'

  #def index
  #
  #end

  def chat_node
    @messages = params[:message]
    unless @messages.is_a? Array
      @messages = [@messages]
    end

    @direction = params[:direction]
    @timestamp = params[:timestamp]

    @messages.each do |message|
      ChatNode.create(
                  #chat: @chat,
          message: message,
          direction: @direction,
          timestamp: @timestamp,
          active: true
      )
    end

    render 'chats/nodes/chat_nodes.js'
  end

end
