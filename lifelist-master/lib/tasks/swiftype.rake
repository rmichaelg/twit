namespace :swiftype do
  task :index_users => :environment do
    if ENV['SWIFTYPE_API_KEY'].blank?
      abort("SWIFTYPE_API_KEY not set")
    end

    if ENV['SWIFTYPE_ENGINE_SLUG'].blank?
      abort("SWIFTYPE_ENGINE_SLUG not set")
    end

    client = Swiftype::Easy.new

    User.find_in_batches(batch_size: 100) do |users|
      documents = users.map do |user|
        { external_id: user.id,
          fields: user.swiftype_fields }
      end

      results = client.create_or_update_documents(ENV['SWIFTYPE_ENGINE_SLUG'], User.model_name.downcase.pluralize, documents)
      results.each_with_index do |result, index|
        puts "Could not create #{users[index].full_name} (##{users[index].id})" if result == false
      end
    end
  end

  task :index_goals => :environment do
    if ENV['SWIFTYPE_API_KEY'].blank?
      abort("SWIFTYPE_API_KEY not set")
    end

    if ENV['SWIFTYPE_ENGINE_SLUG'].blank?
      abort("SWIFTYPE_ENGINE_SLUG not set")
    end

    client = Swiftype::Easy.new

    Goal.find_in_batches(batch_size: 100) do |goals|
      documents = goals.map do |goal|
        { external_id: goal.id,
          fields: goal.swiftype_fields }
      end

      results = client.create_or_update_documents(ENV['SWIFTYPE_ENGINE_SLUG'], Goal.model_name.downcase.pluralize, documents)
      results.each_with_index do |result, index|
        puts "Could not create #{goals[index].full_name} (##{goals[index].id})" if result == false
      end
    end
  end
end
