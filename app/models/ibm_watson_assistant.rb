class IBMWatsonAssistant

  @@service = IBMWatson::AssistantV1.new(
      username: 'TODO',
      password: "TODO",
      version: '2018-09-17'
  )

  @@workspace_id = 'TODO'

  def self.message(text, context)
    if context == 'undefined' || context.blank?
      context = {
          metadata: {
              deployment: 'oberoesterreichtourismus'
          }
      }
    else
      context = JSON.parse context
    end

    response = @@service.message(
        workspace_id: @@workspace_id,
        input: {
            'text': text
        },
        context: context
    ).result
    #puts JSON.pretty_generate(response)

    {
        output: response['output']['text'],
        context: response['context']
    }
  end

end
