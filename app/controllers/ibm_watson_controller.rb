class IbmWatsonController < ApplicationController
  layout 'application'

  def ask_assistant
    @question = params[:message]
    @context = params[:context]
    @response = IBMWatsonAssistant.message(@question, @context)
    @answers = @response[:output]
    @context = @response[:context]
    @suggestions = @context.present? ? @context[:suggestions] : []

    render 'chats/nodes/answer_nodes.js',
           answers: @answers,
           context: @context,
           suggestions: @suggestions
  end

  def show
    # shows already initialized request (ticket)
  end

  def new
    # creates new request
  end

end
