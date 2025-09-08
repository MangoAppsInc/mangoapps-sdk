# frozen_string_literal: true

require_relative "../real_spec_helper"
require_relative "../shared_test_helpers"

RSpec.describe "MangoApps Tasks Module" do
  include SharedTestHelpers
  let(:config) { MangoApps::Config.new }
  let(:client) { MangoApps::Client.new(config) }

  describe "Tasks Module" do
    describe "Get Tasks" do
      it "gets user tasks from actual MangoApps API" do
        puts "\n📋 Testing Tasks API - Get Tasks..."

        response = client.get_tasks(filter: "Pending_Tasks", page: 1, limit: 5)

        expect(response).to be_a(MangoApps::Response)
        expect(response).to respond_to(:tasks)
        puts "✅ Get tasks API call successful!"
        puts "📋 Response contains tasks data"

        if response.tasks
          tasks = response.tasks
          expect(tasks).to respond_to(:task)
          puts "✅ Tasks structure validated"

          if tasks.task && tasks.task.any?
            task_list = tasks.task
            expect(task_list).to be_an(Array)
            puts "📋 Found #{task_list.length} tasks"

            # Test first task structure
            task = task_list.first
            expect(task).to respond_to(:id)
            expect(task).to respond_to(:is_overdue)
            expect(task).to respond_to(:stage_id)
            expect(task).to respond_to(:stage_name)
            expect(task).to respond_to(:date_selection)
            expect(task).to respond_to(:is_site_child)
            expect(task).to respond_to(:task_can_be_started)
            expect(task).to respond_to(:auto_expire_on_overdue)
            expect(task).to respond_to(:accepted_on)
            expect(task).to respond_to(:assigned_on)
            expect(task).to respond_to(:assigned_to)
            expect(task).to respond_to(:assigned_to_name)
            expect(task).to respond_to(:best_case)
            expect(task).to respond_to(:best_case_unit)
            expect(task).to respond_to(:bucket)
            expect(task).to respond_to(:created_at)
            expect(task).to respond_to(:creator_id)
            expect(task).to respond_to(:creator_name)
            expect(task).to respond_to(:delivered_on)
            expect(task).to respond_to(:document_position)
            expect(task).to respond_to(:document_priority)
            expect(task).to respond_to(:due)
            expect(task).to respond_to(:due_on)
            expect(task).to respond_to(:finished_on)
            expect(task).to respond_to(:milestone)
            expect(task).to respond_to(:milestone_id)
            expect(task).to respond_to(:milestone_name)
            expect(task).to respond_to(:milestone_position)
            expect(task).to respond_to(:milestone_priority)
            expect(task).to respond_to(:name)
            expect(task).to respond_to(:notes)
            expect(task).to respond_to(:personal_priority)
            expect(task).to respond_to(:profile_position)
            expect(task).to respond_to(:project_id)
            expect(task).to respond_to(:conversation_name)
            expect(task).to respond_to(:project_position)
            expect(task).to respond_to(:project_priority)
            expect(task).to respond_to(:reassigned_on)
            expect(task).to respond_to(:rejected_on)
            expect(task).to respond_to(:reopened_on)
            expect(task).to respond_to(:restarted_on)
            expect(task).to respond_to(:start_on)
            expect(task).to respond_to(:started_on)
            expect(task).to respond_to(:status)
            expect(task).to respond_to(:type)
            expect(task).to respond_to(:task_identifier)
            expect(task).to respond_to(:task_property_type_id)
            expect(task).to respond_to(:task_property_priority_id)
            expect(task).to respond_to(:updated_at)
            expect(task).to respond_to(:visibility)
            expect(task).to respond_to(:worst_case)
            expect(task).to respond_to(:worst_case_unit)
            expect(task).to respond_to(:task_title)
            expect(task).to respond_to(:cta_enabled)
            expect(task).to respond_to(:sub_tasks)
            expect(task).to respond_to(:reviewers)
            expect(task).to respond_to(:next_actions)
            expect(task).to respond_to(:mlink)
            expect(task).to respond_to(:attachments)
            expect(task).to respond_to(:attachment_references)
            puts "✅ Task structure validated"
            puts "📋 Sample task: #{task.task_title} (ID: #{task.id})"
            puts "👤 Assigned to: #{task.assigned_to_name} (ID: #{task.assigned_to})"
            puts "👤 Created by: #{task.creator_name} (ID: #{task.creator_id})"
            puts "📊 Status: #{task.status} | Bucket: #{task.bucket}"
            puts "📅 Created: #{Time.at(task.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            puts "📅 Assigned: #{Time.at(task.assigned_on.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            puts "⏰ Due: #{task.due} | Due on: #{task.due_on ? Time.at(task.due_on.to_i).strftime('%Y-%m-%d %H:%M:%S') : 'None'}"
            puts "🚨 Is overdue: #{task.is_overdue} | Can be started: #{task.task_can_be_started}"
            puts "🎯 Milestone: #{task.milestone_name || 'None'} (ID: #{task.milestone_id || 'None'})"
            puts "💼 Project: #{task.conversation_name} (ID: #{task.project_id})"
            puts "🔒 Visibility: #{task.visibility} | Priority: #{task.personal_priority}"

            # Test reviewers
            if task.reviewers && task.reviewers.reviewer
              reviewers = task.reviewers.reviewer
              expect(reviewers).to be_an(Array)
              puts "✅ Reviewers structure validated"
              puts "👥 Reviewers: #{reviewers.length} reviewers"
              
              if reviewers.any?
                reviewer = reviewers.first
                expect(reviewer).to respond_to(:id)
                expect(reviewer).to respond_to(:task_id)
                expect(reviewer).to respond_to(:user_id)
                expect(reviewer).to respond_to(:user_name)
                expect(reviewer).to respond_to(:created_at)
                expect(reviewer).to respond_to(:reviewer_on)
                expect(reviewer).to respond_to(:status)
                expect(reviewer).to respond_to(:updated_at)
                puts "✅ Reviewer structure validated"
                puts "👤 Sample reviewer: #{reviewer.user_name} (ID: #{reviewer.user_id})"
                puts "📊 Review status: #{reviewer.status}"
                puts "📅 Created: #{Time.at(reviewer.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
              end
            end

            # Test next actions
            if task.next_actions && task.next_actions.action
              actions = task.next_actions.action
              expect(actions).to be_an(Array)
              puts "✅ Next actions structure validated"
              puts "⚡ Available actions: #{actions.join(', ')}"
            end

            # Test links
            if task.respond_to?(:mlink)
              puts "🔗 MLink: #{task.mlink[0..50]}..."
            end

            # Test attachments
            if task.attachments
              puts "📎 Attachments: #{task.attachments.length} attachments"
            end
            if task.attachment_references
              puts "📎 Attachment references: #{task.attachment_references.length} references"
            end

            # Test transaction_id
            if response.respond_to?(:transaction_id)
              puts "✅ Transaction ID: #{response.transaction_id || 'None'}"
            end
          else
            puts "📋 Tasks list is empty"
          end
        else
          puts "📋 Tasks data not found"
        end

        expect(response).to respond_to(:tasks)
        puts "✅ Response structure validated"
      end
    end

    describe "Get Task Details" do
      it "gets detailed information for a specific task" do
        puts "\n📋 Testing Tasks API - Get Task Details..."

        # First get tasks to find a task ID to test with
        tasks_response = client.get_tasks(filter: "Pending_Tasks", page: 1, limit: 1)
        expect(tasks_response).to be_a(MangoApps::Response)
        expect(tasks_response.tasks).to respond_to(:task)
        
        # Find a task to test with
        if tasks_response.tasks.task && tasks_response.tasks.task.any?
          test_task = tasks_response.tasks.task.first
          
          # Handle the case where test_task is an array instead of a hash
          if test_task.is_a?(Array)
            task_id = test_task[1] # ID is at index 1
            puts "📋 Testing with task ID: #{task_id}"
          else
            task_id = test_task.id
            puts "📋 Testing with task: #{test_task.task_title} (ID: #{task_id})"
          end
          
          response = client.get_task_details(task_id)

          expect(response).to be_a(MangoApps::Response)
          expect(response).to respond_to(:task)
          puts "✅ Get task details API call successful!"
          puts "📋 Response contains task details data"

          if response.task
            task = response.task
            expect(task).to respond_to(:id)
            expect(task).to respond_to(:is_overdue)
            expect(task).to respond_to(:stage_id)
            expect(task).to respond_to(:stage_name)
            expect(task).to respond_to(:date_selection)
            expect(task).to respond_to(:is_site_child)
            expect(task).to respond_to(:task_can_be_started)
            expect(task).to respond_to(:auto_expire_on_overdue)
            expect(task).to respond_to(:accepted_on)
            expect(task).to respond_to(:assigned_on)
            expect(task).to respond_to(:assigned_to)
            expect(task).to respond_to(:assigned_to_name)
            expect(task).to respond_to(:best_case)
            expect(task).to respond_to(:best_case_unit)
            expect(task).to respond_to(:bucket)
            expect(task).to respond_to(:created_at)
            expect(task).to respond_to(:creator_id)
            expect(task).to respond_to(:creator_name)
            expect(task).to respond_to(:delivered_on)
            expect(task).to respond_to(:document_position)
            expect(task).to respond_to(:document_priority)
            expect(task).to respond_to(:due)
            expect(task).to respond_to(:due_on)
            expect(task).to respond_to(:finished_on)
            expect(task).to respond_to(:milestone)
            expect(task).to respond_to(:milestone_id)
            expect(task).to respond_to(:milestone_name)
            expect(task).to respond_to(:milestone_position)
            expect(task).to respond_to(:milestone_priority)
            expect(task).to respond_to(:name)
            expect(task).to respond_to(:notes)
            expect(task).to respond_to(:personal_priority)
            expect(task).to respond_to(:profile_position)
            expect(task).to respond_to(:project_id)
            expect(task).to respond_to(:conversation_name)
            expect(task).to respond_to(:project_position)
            expect(task).to respond_to(:project_priority)
            expect(task).to respond_to(:reassigned_on)
            expect(task).to respond_to(:rejected_on)
            expect(task).to respond_to(:reopened_on)
            expect(task).to respond_to(:restarted_on)
            expect(task).to respond_to(:start_on)
            expect(task).to respond_to(:started_on)
            expect(task).to respond_to(:status)
            expect(task).to respond_to(:type)
            expect(task).to respond_to(:task_identifier)
            expect(task).to respond_to(:task_property_type_id)
            expect(task).to respond_to(:task_property_priority_id)
            expect(task).to respond_to(:updated_at)
            expect(task).to respond_to(:visibility)
            expect(task).to respond_to(:worst_case)
            expect(task).to respond_to(:worst_case_unit)
            expect(task).to respond_to(:task_title)
            expect(task).to respond_to(:cta_enabled)
            expect(task).to respond_to(:sub_tasks)
            expect(task).to respond_to(:reviewers)
            expect(task).to respond_to(:next_actions)
            expect(task).to respond_to(:mlink)
            expect(task).to respond_to(:attachments)
            expect(task).to respond_to(:attachment_references)
            puts "✅ Task details structure validated"
            puts "📋 Task: #{task.task_title} (ID: #{task.id})"
            puts "👤 Assigned to: #{task.assigned_to_name} (ID: #{task.assigned_to})"
            puts "👤 Created by: #{task.creator_name} (ID: #{task.creator_id})"
            puts "📊 Status: #{task.status} | Bucket: #{task.bucket}"
            puts "📅 Created: #{Time.at(task.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            puts "📅 Assigned: #{Time.at(task.assigned_on.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            puts "⏰ Due: #{task.due} | Due on: #{task.due_on ? Time.at(task.due_on.to_i).strftime('%Y-%m-%d %H:%M:%S') : 'None'}"
            puts "🚨 Is overdue: #{task.is_overdue} | Can be started: #{task.task_can_be_started}"
            puts "🎯 Milestone: #{task.milestone_name || 'None'} (ID: #{task.milestone_id || 'None'})"
            puts "💼 Project: #{task.conversation_name} (ID: #{task.project_id})"
            puts "🔒 Visibility: #{task.visibility} | Priority: #{task.personal_priority}"

            # Test task timeline
            if task.respond_to?(:started_on) && task.started_on
              puts "📅 Started: #{Time.at(task.started_on.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            end
            if task.respond_to?(:finished_on) && task.finished_on
              puts "📅 Finished: #{Time.at(task.finished_on.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            end
            if task.respond_to?(:delivered_on) && task.delivered_on
              puts "📅 Delivered: #{Time.at(task.delivered_on.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            end

            # Test task history
            if task.respond_to?(:reopened_on) && task.reopened_on
              puts "📅 Reopened: #{Time.at(task.reopened_on.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            end
            if task.respond_to?(:restarted_on) && task.restarted_on
              puts "📅 Restarted: #{Time.at(task.restarted_on.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
            end

            # Test reviewers
            if task.reviewers && task.reviewers.reviewer
              reviewers = task.reviewers.reviewer
              expect(reviewers).to be_an(Array)
              puts "✅ Reviewers structure validated"
              puts "👥 Reviewers: #{reviewers.length} reviewers"
              
              if reviewers.any?
                reviewer = reviewers.first
                expect(reviewer).to respond_to(:id)
                expect(reviewer).to respond_to(:task_id)
                expect(reviewer).to respond_to(:user_id)
                expect(reviewer).to respond_to(:user_name)
                expect(reviewer).to respond_to(:created_at)
                expect(reviewer).to respond_to(:reviewer_on)
                expect(reviewer).to respond_to(:status)
                expect(reviewer).to respond_to(:updated_at)
                puts "✅ Reviewer structure validated"
                puts "👤 Sample reviewer: #{reviewer.user_name} (ID: #{reviewer.user_id})"
                puts "📊 Review status: #{reviewer.status}"
                puts "📅 Created: #{Time.at(reviewer.created_at.to_i).strftime('%Y-%m-%d %H:%M:%S')}"
              end
            end

            # Test next actions
            if task.next_actions && task.next_actions.action
              actions = task.next_actions.action
              expect(actions).to be_an(Array)
              puts "✅ Next actions structure validated"
              puts "⚡ Available actions: #{actions.join(', ')}"
            end

            # Test links
            if task.respond_to?(:mlink)
              puts "🔗 MLink: #{task.mlink[0..50]}..."
            end

            # Test attachments
            if task.attachments
              puts "📎 Attachments: #{task.attachments.length} attachments"
            end
            if task.attachment_references
              puts "📎 Attachment references: #{task.attachment_references.length} references"
            end

            # Test task content
            if task.respond_to?(:name) && task.name
              puts "📝 Task content: #{task.name[0..100]}..."
            end
            if task.respond_to?(:notes) && task.notes
              puts "📝 Notes: #{task.notes[0..100]}..."
            end

            # Test transaction_id
            if response.respond_to?(:transaction_id)
              puts "✅ Transaction ID: #{response.transaction_id || 'None'}"
            end
          else
            puts "📋 Task details data not found"
          end

          expect(response).to respond_to(:task)
          puts "✅ Response structure validated"
        else
          puts "📋 No tasks found to test with"
          puts "✅ Skipping task details test - no suitable test task available"
        end
      end
    end
  end
end
