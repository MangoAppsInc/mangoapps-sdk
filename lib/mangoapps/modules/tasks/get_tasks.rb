# frozen_string_literal: true

module MangoApps
  class Client
    module Tasks
      module GetTasks
        def get_tasks(params = {})
          get("tasks/new_index.json", params: params)
        end
      end
    end
  end
end
