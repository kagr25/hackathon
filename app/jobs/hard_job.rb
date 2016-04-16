class HardJob < ActiveJob::Base
  # Set the Queue as Default
  queue_as :default

  def perform(name)
    puts "Hello > #{name}"
    Item.create!(name: name, item_id: name, price: 10)
  end
end