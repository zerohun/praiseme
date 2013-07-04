namespace :search_suggestion do
  task :stamp_index => :environment do
    StampSuggestion.index_names

  end
end
