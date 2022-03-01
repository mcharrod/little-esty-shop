class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :first_name
  validates_presence_of :last_name


  def self.top_five
    # join all customers to transactions through invoices
    all.joins(invoices: :transactions)
    # only select the successful transactions
    .where(['transactions.result = ?', 0])
    # group by customer id
    .group(:id)
    # order by each customers transaction count, return 5 results.
    .order('transactions.count desc').limit(5)
  end


  def transaction_count
    self.transactions.where(result: 0).count
  end
end
