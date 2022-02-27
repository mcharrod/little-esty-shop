require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'attributes' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
  end

  it 'exists' do
    item = create(:item)
    expect(item).to be_a(Item)
    expect(item). to be_valid
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  it 'item toggle status' do
    merchant = create(:merchant)

    item1 = create(:item, merchant: merchant)

      expect(item1.status).to eq("disabled")

      item1.update({ status: "enabled" })
      item1.reload

      expect(item1.status).to eq("enabled")

      item1.update({ status: "disabled" })
      item1.reload

      expect(item1.status).to eq("disabled")
  end

    it  "best day with top five items setup" do
      merchant1 = Merchant.create!(name: "The Tornado")
      item1 = merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
      item2 = merchant1.items.create!(name: "FunPants", description: "Cha + 20", unit_price: 2000)
      item3 = merchant1.items.create!(name: "FitPants", description: "Con + 20", unit_price: 150)
      item4 = merchant1.items.create!(name: "VeinyShorts", description: "Str + 20", unit_price: 1400)
      item5 = merchant1.items.create!(name: "SpringSocks", description: "DX + 20", unit_price: 375)
      item6 = merchant1.items.create!(name: "UnderRoos", description: "SNUG!", unit_price: 25)
      item7 = merchant1.items.create!(name: "SunStoppers", description: "Eclipse ready!", unit_price: 50)
      customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
      customer2 = Customer.create!(first_name: "Larky", last_name: "Lark" )
      customer3 = Customer.create!(first_name: "Sparky", last_name: "Spark" )
      customer4 = Customer.create!(first_name: "Farky", last_name: "Fark" )

      invoice1 = customer1.invoices.create!(status: 2, created_at: "2014-05-22")
      invoice2 = customer2.invoices.create!(status: 2, created_at: "2014-05-21")
      invoice3 = customer3.invoices.create!(status: 2, created_at: "2014-05-20")
      invoice4 = customer4.invoices.create!(status: 2, created_at: "2014-05-22")
      invoice5 = customer4.invoices.create!(status: 2, created_at: "2014-05-19")

      invoice_item2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
      invoice_item4 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 120, status: 1)
      invoice_item7 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: item7.id, quantity: 15, unit_price: 50, status: 2)
      invoice_item3 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: item3.id, quantity: 5, unit_price: 125, status: 0)
      invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 2, unit_price: 125, status: 0)
      invoice_item6 = InvoiceItem.create!(invoice_id: invoice4.id, item_id: item6.id, quantity: 20, unit_price: 25, status: 2)
      invoice_item5 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: item2.id, quantity: 2, unit_price: 2000, status: 1)
      invoice_item8 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: item2.id, quantity: 1, unit_price: 2000, status: 1)
      invoice_item9 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: item4.id, quantity: 3, unit_price: 1400, status: 2)

      transaction1 = Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice1.id)
      transaction2 = Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice2.id)
      transaction3 = Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice3.id)
      transaction4 = Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice4.id)
      transaction5 = Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice5.id)

      expect(item1.best_day).to eq("Thursday, May 22, 2014")
      expect(item2.best_day).to eq("Tuesday, May 20, 2014")
      expect(item3.best_day).to eq("Monday, May 19, 2014")
    end
end
