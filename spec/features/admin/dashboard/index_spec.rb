require 'rails_helper'

describe 'Admin Dashboard Index Page' do
  before :each do
    @merchant1 = Merchant.create!(name: "The Tornado")
    @item1 = @merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 125)
    @item2 = @merchant1.items.create!(name: "FunPans", description: "Cha + 20", unit_price: 2000)
    @item3 = @merchant1.items.create!(name: "FitPants", description: "Con + 20", unit_price: 150)
    @customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    @customer2 = Customer.create!(first_name: "Larky", last_name: "Lark" )
    @customer3 = Customer.create!(first_name: "Sparky", last_name: "Spark" )
    @customer4 = Customer.create!(first_name: "Farky", last_name: "Fark" )
    @invoice1 = @customer1.invoices.create!(status: 0)
    @invoice2 = @customer2.invoices.create!(status: 0)
    @invoice3 = @customer3.invoices.create!(status: 0)
    @invoice4 = @customer4.invoices.create!(status: 2)
    @invoice5 = @customer4.invoices.create!(status: 1)
    # invoice1 will test both items packaged
    @invoice_item1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, quantity: 2, unit_price: 125, status: 0)
    @invoice_item2 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item2.id, quantity: 2, unit_price: 2000, status: 0)

    # invoice2 will test 1 item packaged, 1 item pending.
    @invoice_item3 = InvoiceItem.create!(invoice_id: @invoice2.id, item_id: @item3.id, quantity: 5, unit_price: 125, status: 0)
    @invoice_item4 = InvoiceItem.create!(invoice_id: @invoice2.id, item_id: @item1.id, quantity: 2, unit_price: 125, status: 1)

    # invoice3 will test both packages pending
    @invoice_item5 = InvoiceItem.create!(invoice_id: @invoice3.id, item_id: @item2.id, quantity: 2, unit_price: 2000, status: 1)
    @invoice_item8 = InvoiceItem.create!(invoice_id: @invoice3.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 1)

    #invoice 4 will test completed order with all items shipped, it should not appear
    @invoice_item6 = InvoiceItem.create!(invoice_id: @invoice4.id, item_id: @item3.id, quantity: 1, unit_price: 125, status: 2)
    @invoice_item7 = InvoiceItem.create!(invoice_id: @invoice4.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)
    #invoice 5 was cancelled so it will test that canceled orders will not appear.
    @invoice_item9 = InvoiceItem.create!(invoice_id: @invoice5.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)
  end

  it 'should display a header indicating the admin dashboard' do
    visit '/admin'
    expect(page).to have_content('Admin Dashboard')
  end

  it 'should have links to merchants and invoices index' do
    visit '/admin'
    click_button "View Invoices"

    expect(current_path).to eq("/admin/invoices")

    visit '/admin'
    click_button "View Merchants"

    expect(current_path).to eq("/admin/merchants")
  end


  it 'displays all open invoices' do
    invoice1 = create(:invoice, status: "in progress")
    invoice2 = create(:invoice, status: "cancelled")
    invoice3 = create(:invoice, status: "completed")
    invoice4 = create(:invoice, status: "in progress")
    invoice5 = create(:invoice, status: "completed")
    invoice6 = create(:invoice, status: "in progress")

    visit ('/admin')

    expect(page).to have_content("Invoice Number: #{invoice1.id}")
    expect(page).to have_content("Invoice Number: #{invoice4.id}")
    expect(page).to have_content("Invoice Number: #{invoice6.id}")
    expect(page).to_not have_content("Invoice Number: #{invoice2.id}")
    expect(page).to_not have_content("Invoice Number: #{invoice3.id}")
    expect(page).to_not have_content("Invoice Number: #{invoice5.id}")
  end

  it 'displays invoice created dates in the correct format' do
    invoice1 = create(:invoice, status: "in progress", created_at: "Tue, 06 Mar 2012 15:54:17 UTC +00:00")

    visit ('/admin')

    expect(page).to have_content("Invoice Number: #{invoice1.id} - created Tuesday, March 06, 2012")
  end
  it "lists the invoices that are incomplete " do
    visit '/admin'

    expect(page).to have_link("Invoice ID: #{@invoice1.id}")
    expect(page).to have_link("Invoice ID: #{@invoice2.id}")
    expect(page).to have_link("Invoice ID: #{@invoice3.id}")
    expect(page).to_not have_content("Invoice ID: #{@invoice4.id}")
    expect(page).to_not have_content("Invoice ID: #{@invoice5.id}")
  end

  it "has links on Invoices that go to show pages." do
    visit '/admin'

    click_link("Invoice ID: #{@invoice1.id}")
    expect(current_path).to eq("/admin/invoices/#{@invoice1.id}")
  end
end

RSpec.describe "Admin dashboard" do

  it "US20 - Top 5 Customers" do
    # highest to lowest successful transactions: 4(5), 1(4), 5(3), 7(2), 2(1).

    # Customer 8 will have no transactions or invoices
    customer8 = create(:customer)

    # Customer 3 will have 1 failed transaction over 1 invoice
    customer3 = create(:customer)
    invoice1 = create(:invoice, customer_id: customer3.id)
    create(:transaction, result: 1, invoice_id: invoice1.id)

    # Customer 6 will have 7 failed transactions on 1 invoice
    customer6 = create(:customer, first_name: "DO NOT SHOW ME GOD")
    invoice1 = create(:invoice, customer_id: customer6.id)
    create(:transaction, result: 1, invoice_id: invoice1.id)
    create(:transaction, result: 1, invoice_id: invoice1.id)
    create(:transaction, result: 1, invoice_id: invoice1.id)
    create(:transaction, result: 1, invoice_id: invoice1.id)
    create(:transaction, result: 1, invoice_id: invoice1.id)
    create(:transaction, result: 1, invoice_id: invoice1.id)
    create(:transaction, result: 1, invoice_id: invoice1.id)

    # Customer 2 will have 1 successful transactions on 1 invoice
    customer2 = create(:customer, first_name: "fifth place")
    invoice1 = create(:invoice, customer_id: customer2.id)
    create(:transaction, result: 0, invoice_id: invoice1.id)

    # Customer 7 will have 2 successful transactions on 2 invoices
    customer7 = create(:customer, first_name: "fourth place")
    invoice1 = create(:invoice, customer_id: customer7.id)
    invoice2 = create(:invoice, customer_id: customer7.id)
    create(:transaction, result: 0, invoice_id: invoice1.id)
    create(:transaction, result: 0, invoice_id: invoice2.id)

    # Customer 5 will have 3 successful transactions over 1 invoice
    customer5 = create(:customer, first_name: "third place")
    invoice1 = create(:invoice, customer_id: customer5.id)
    create(:transaction, result: 0, invoice_id: invoice1.id)
    create(:transaction, result: 0, invoice_id: invoice1.id)
    create(:transaction, result: 0, invoice_id: invoice1.id)

    # Customer 1 will have 4 successful transactions over 4 invoices
    customer1 = create(:customer, first_name: "second place")
    invoice1 = create(:invoice, customer_id: customer1.id)
    invoice2 = create(:invoice, customer_id: customer1.id)
    invoice3 = create(:invoice, customer_id: customer1.id)
    invoice4 = create(:invoice, customer_id: customer1.id)
    create(:transaction, result: 0, invoice_id: invoice1.id)
    create(:transaction, result: 0, invoice_id: invoice2.id)
    create(:transaction, result: 0, invoice_id: invoice3.id)
    create(:transaction, result: 0, invoice_id: invoice4.id)

    # Customer 4 will have 5 successful and 2 failed transactions over 3 invoices
    customer4 = create(:customer, first_name: "winner winner chicken dinner")
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

    visit '/admin'

    # highest to lowest successful transactions: 4(5), 1(4), 5(3), 7(2), 2(1).

    # Finally we get to test something!
    within("#top-customers") do
      expect(page).to have_content("Top 5 Customers")
      expect(page).to have_content("1. #{customer4.first_name}: successful transactions: 5")
      expect(page).to have_content("2. #{customer1.first_name}: successful transactions: 4")
      expect(page).to have_content("3. #{customer5.first_name}: successful transactions: 3")
      expect(page).to have_content("4. #{customer7.first_name}: successful transactions: 2")
      expect(page).to have_content("5. #{customer2.first_name}: successful transactions: 1")

      expect(page).to_not have_content("#{customer3.first_name}")
      expect(page).to_not have_content("#{customer6.first_name}")
      expect(page).to_not have_content("#{customer8.first_name}")
    end
  end
end
