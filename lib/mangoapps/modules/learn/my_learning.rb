# frozen_string_literal: true

module MangoApps
  class Client
    module Learn
      module MyLearning
        def my_learning(params = {})
          get("v2/learn/my_learning.json", params: params)
        end
      end
    end
  end
end
