require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'attributes' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  it 'exists' do
    customer = create(:customer)

    expect(customer).to be_a(Customer)
    expect(customer).to be_valid
  end

  describe 'relationships' do
    it { should have_many(:invoices)}
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'class methods' do
    it 'US20 - Top 5 Customers' do
      # most to least : customer4, customer1, customer5, customer7, customer2

      # Customer 1 will have 4 successful transactions over 4 invoices
      customer1 = create(:customer)
      invoice1 = create(:invoice, customer_id: customer1.id)
      invoice2 = create(:invoice, customer_id: customer1.id)
      invoice3 = create(:invoice, customer_id: customer1.id)
      invoice4 = create(:invoice, customer_id: customer1.id)
      create(:transaction, result: 0, invoice_id: invoice1.id)
      create(:transaction, result: 0, invoice_id: invoice2.id)
      create(:transaction, result: 0, invoice_id: invoice3.id)
      create(:transaction, result: 0, invoice_id: invoice4.id)

      # Customer 2 will have 1 successful transactions on 1 invoice
      customer2 = create(:customer)
      invoice1 = create(:invoice, customer_id: customer2.id)
      create(:transaction, result: 0, invoice_id: invoice1.id)

      # Customer 3 will have 1 failed transaction over 1 invoice
      customer3 = create(:customer)
      invoice1 = create(:invoice, customer_id: customer3.id)
      create(:transaction, result: 1, invoice_id: invoice1.id)

      # Customer 4 will have 5 successful and 2 failed transactions over 3 invoices
      customer4 = create(:customer)
      invoice1 = create(:invoice, customer_id: customer4.id)
      invoice2 = create(:invoice, customer_id: customer4.id)
      invoice3 = create(:invoice, customer_id: customer4.id)
      create(:transaction, result: 0, invoice_id: invoice1.id)
      create(:transaction, result: 0, invoice_id: invoice2.id)
      create(:transaction, result: 0, invoice_id: invoice3.id)
      create(:transaction, result: 0, invoice_id: invoice1.id)
      create(:transaction, result: 0, invoice_id: invoice2.id)
      create(:transaction, result: 1, invoice_id: invoice3.id)
      create(:transaction, result: 1, invoice_id: invoice1.id)

      # Customer 5 will have 3 successful transactions over 1 invoice
      customer5 = create(:customer)
      invoice1 = create(:invoice, customer_id: customer5.id)
      create(:transaction, result: 0, invoice_id: invoice1.id)
      create(:transaction, result: 0, invoice_id: invoice1.id)
      create(:transaction, result: 0, invoice_id: invoice1.id)

      # Customer 6 will have 7 failed transactions on 1 invoice
      customer6 = create(:customer)
      invoice1 = create(:invoice, customer_id: customer6.id)
      create(:transaction, result: 1, invoice_id: invoice1.id)
      create(:transaction, result: 1, invoice_id: invoice1.id)
      create(:transaction, result: 1, invoice_id: invoice1.id)
      create(:transaction, result: 1, invoice_id: invoice1.id)
      create(:transaction, result: 1, invoice_id: invoice1.id)
      create(:transaction, result: 1, invoice_id: invoice1.id)
      create(:transaction, result: 1, invoice_id: invoice1.id)

      # Customer 7 will have 2 successful transactions on 2 invoices
      customer7 = create(:customer)
      invoice1 = create(:invoice, customer_id: customer7.id)
      invoice2 = create(:invoice, customer_id: customer7.id)
      create(:transaction, result: 0, invoice_id: invoice1.id)
      create(:transaction, result: 0, invoice_id: invoice2.id)

      # Customer 8 will have no transactions or invoices
      customer8 = create(:customer)

      # Finally we get to test something!
      expect(Customer.top_five).to eq([customer4, customer1, customer5, customer7, customer2])
    end
  end
end
