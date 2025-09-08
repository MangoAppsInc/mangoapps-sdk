# frozen_string_literal: true

require_relative "tasks/get_tasks"
require_relative "tasks/get_task_details"

module MangoApps
  class Client
    module Tasks
      # Include all tasks sub-modules
      include MangoApps::Client::Tasks::GetTasks
      include MangoApps::Client::Tasks::GetTaskDetails
    end
  end
end
