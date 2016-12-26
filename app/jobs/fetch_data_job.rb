class FetchDataJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |error|
    ap error
  end

  def perform(user)
    user.update!(state: :processing)
    access_token = user.token
    begin_time = (Time.now - 3.years).to_datetime.rfc3339
    end_time = Time.now.to_datetime.rfc3339
    locationApi = SquareConnect::LocationApi.new()
    list_of_locations = locationApi.list_locations(access_token)
    locations = list_of_locations.locations || []
    save_locations(user, locations)
    locations.each do |location|
      transactionApi = SquareConnect::TransactionApi.new()
      list_of_transactions = transactionApi.list_transactions(
        access_token, location.id, {
          begin_time: begin_time, 
          end_time: end_time})
      transactions = list_of_transactions.transactions || []
      save_transactions(user, location, transactions)
    end
    user.update!(state: :ready)
  end

  private

  def save_locations(user, locations)
    location_ids = locations.map(&:id)
    available_locations = user.locations.where(square_id: location_ids).pluck(:square_id)
    new_locations = locations.select{|l| !available_locations.include?(l.id) }
    new_locations.each do |nl|
      user.locations.create!(name: nl.name, square_id: nl.id)
    end
  end

  def save_transactions(user, square_loc, transactions)
    location = user.locations.find_by_square_id(square_loc.id)
    transaction_ids = transactions.map(&:id)
    available_transactions = location.transactions.where(square_id: transaction_ids).pluck(:square_id)
    new_transactions = transactions.select{|t| !available_transactions.include?(t.id) }
    new_transactions.each do |nt|
      location.transactions.create!(
        user: location.user,
        amount: nt.tenders.inject(0){|sum, n| sum + n.amount_money.amount},
        currency: nt.tenders.first.amount_money.currency,
        square_id: nt.id,
        square_created_at: nt.created_at)
    end
  end
end