define [
  './config'
], (
  config
) ->


  [
    {
      name: 'Mass Relevance'
      time:
        end: 8 * config.hour
    }
    {
      name: 'Exercise (Cardio)'
      time:
        end: 30 * config.minute
    }
    {
      name: 'Exercise (Strength)'
      time:
        end: 1 * config.hour
    }
    # {
    #   name: 'Sell Items'
    #   time:
    #     end: 2 * config.hour
    # }
    # {
    #   name: 'Sneeze'
    #   time:
    #     end: 3 * config.second
    # }
  ]
