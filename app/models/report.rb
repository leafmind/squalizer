class Report < ApplicationRecord
  belongs_to :user

  after_create_commit { ProcessDataJob.perform_later(self) if self.state.to_sym == :fetch }

  serialize :statistics, Hash
  serialize :average, Hash

  # https://docs.connect.squareup.com/api/connect/v2/#type-money
  #
  # Important: Unlike version 1 of the Connect API, all monetary amounts returned by v2 endpoints are positive. 
  # (In v1, monetary amounts are negative if they represent money being paid by a merchant, 
  # instead of money being paid to a merchant.)
  def build_statistics
  	yearly_monthly_stats = {}
  	prev_square_created_at = nil
  	monthly_stats = {}
  	number_of_charges = 0
    total_incoming_amount = 0
    user.transactions.ordered.each do |t|
      if !prev_square_created_at || (prev_square_created_at && (t.square_created_at.month != prev_square_created_at.month))
        monthly_stats[prev_square_created_at.month] = {
          number_of_charges: number_of_charges,
          total_incoming_amount: total_incoming_amount
        } if prev_square_created_at
        
        if prev_square_created_at && prev_square_created_at.year != t.square_created_at.year
          yearly_monthly_stats[prev_square_created_at.year] = monthly_stats
          monthly_stats = {}
        end
        
        number_of_charges = 0
        total_incoming_amount = 0
        prev_square_created_at = t.square_created_at
      end
      number_of_charges += 1
      total_incoming_amount += t.amount
    end
    prev_square_created_at = user.transactions.ordered.last.square_created_at
    if number_of_charges > 0
      monthly_stats[prev_square_created_at.month] = {
        number_of_charges: number_of_charges,
        total_incoming_amount: total_incoming_amount
      }
    end
    if monthly_stats.keys.any?
      yearly_monthly_stats[prev_square_created_at.year] = monthly_stats
    end
    y_to_y_change = {}
    (1..12).each do |month|
      y_to_y_change[month] = []
      yearly_monthly_stats.keys.each do |year|
        if y_to_y_change[month]
          y_to_y_change[month] = 0
          if yearly_monthly_stats[year][month]
            yearly_monthly_stats[year][month][:year_to_year_change] = 0
          end
        else
          if yearly_monthly_stats[year][month]
            y_to_y_change[month] << yearly_monthly_stats[year][month].to_f / yearly_monthly_stats[year - 1][month].to_f
            yearly_monthly_stats[year][month][:year_to_year_change] = y_to_y_change[month]
          end
        end
      end
    end
    self.statistics = yearly_monthly_stats
    save
  end

  def build_average
  	last_year = {}
  	number_of_charges = 0
  	total_incoming_amount = 0
  	volatility = 0
    sum_results = Transaction.reorder('').where('square_created_at > ?', Time.now - 12.months).select('sum(amount) as sum')
    total = sum_results.first.try(:[], 'sum').to_f
    avg_total = total / 12.0
    results = Transaction.where('square_created_at > ?', Time.now - 12.months).
      select("count(transactions.id) as count, sum(amount) as amount, date_trunc('month', square_created_at) as month").group('month')
    results.each do |r|
      number_of_charges += r['count']
      total_incoming_amount += r['amount']
      volatility = r['amount'].to_f / avg_total
      last_year[r['month'].to_time.month] = {
      	number_of_charges: r['count'],
      	total_incoming_amount: r['amount'],
      	volatility: volatility
      }
    end
    self.average = {number_of_charges: number_of_charges/12.0, total_incoming_amount: total_incoming_amount/12.0, volatility: volatility/12.0}
    save
  end

end
