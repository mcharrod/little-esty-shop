class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices

  validates_presence_of :name
  validates_presence_of :status

  enum status: { "disabled" => 0, "enabled" => 1 }

  def ready_items
    # order the invoices by created at date, old to new
    # then remove all the items where they are already shipped

     invoice_items.where.not(status: 2)
     .joins(:invoice).order("invoices.created_at")

    # invoices.order(:created_at)
    # .joins(:invoice_items)
    # .where.not(invoice_items: { status: 2 })
  end

  def ordered_items
    items.order(:name)
  end

  def self.enabled
    where(status: 1)
  end

  def self.disabled
    where(status: 0)
  end
end
