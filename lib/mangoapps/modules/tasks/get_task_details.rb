# frozen_string_literal: true

module MangoApps
  class Client
    module Tasks
      module GetTaskDetails
        def get_task_details(task_id, params = {})
          get("tasks/#{task_id}.json", params: params)
        end
      end
    end
  end
end
