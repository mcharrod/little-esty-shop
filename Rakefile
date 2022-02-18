# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'csv'

Rails.application.load_tasks

namespace :csv_load do
  desc 'Howdy! This sure is fun.'
  task :merchants do
    items = []
    CSV.foreach("db/data/merchants.csv", headers: true) do |row|
      items << row.to_h
    end
    binding.pry
    Merchant.import(items)
  end
end

# create_table(:table_name, :id => false) do |t|
#   t.integer :id, :options => 'PRIMARY KEY'
# end
