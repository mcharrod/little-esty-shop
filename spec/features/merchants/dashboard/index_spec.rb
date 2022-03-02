require 'rails_helper'

describe "Merchant Dashboard", type: :feature do
  before do
    @merchant1 = create(:merchant)

    visit "/merchants/#{@merchant1.id}"
  end

  it "displays the name of the merchant on the page" do
    expect(page).to have_content(@merchant1.name)
  end

  it "has a link to merchant item index" do
    click_link("View store items")

    expect(current_path).to eq("/merchants/#{@merchant1.id}/items")
  end

  it 'has a link to merchant invoices index' do
    click_link "View invoices"

    expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices")
  end

  it 'has items ready to ship section' do
    merchant2 = create(:merchant)

    item1 = create(:item, merchant: merchant2)
    item2 = create(:item, merchant: merchant2)

    # item 1 has already been shipped, do not display name
    ii1 = create(:invoice_item, status: "shipped", item: item1)

    # item 2 is packaged, display name
    ii2 = create(:invoice_item, status: "packaged", item: item2)
    ii3 = create(:invoice_item, status: "pending", item: item2)

    visit "/merchants/#{merchant2.id}"

    expect(page).to have_content("Items ready to ship")

    # sad path
    expect(page).not_to have_content(ii1.item.name)

    expect(page).to have_content(ii2.item.name)
    expect(page).to have_content(ii3.item.name)
  end

  it 'links to the invoice page for each ready invoice item' do
    merchant2 = create(:merchant)

    item1 = create(:item, merchant: merchant2)

    invoice1 = create(:invoice)
    invoice2 = create(:invoice)

    ii2 = create(:invoice_item, status: "packaged", item: item1, invoice: invoice1)
    ii3 = create(:invoice_item, status: "pending", item: item1, invoice: invoice2)

    visit "/merchants/#{merchant2.id}"

    within "#invoice_item-#{ii2.id}" do
      click_link "View this invoice"
    end

    expect(current_path).to eq("/merchants/#{merchant2.id}/invoices/#{ii2.invoice.id}")

    # sad path
    expect(current_path).to_not eq("/merchants/#{merchant2.id}/invoices/#{ii3.invoice.id}")

    visit "/merchants/#{merchant2.id}"

    within "#invoice_item-#{ii3.id}" do
      click_link "View this invoice"
    end

    expect(current_path).to eq("/merchants/#{merchant2.id}/invoices/#{ii3.invoice.id}")

    # sad path
    expect(current_path).to_not eq("/merchants/#{merchant2.id}/invoices/#{ii2.invoice.id}")
  end


  it 'orders ready items by oldest first and displays that date' do
    item1 = create(:item, merchant: @merchant1)

    # oldest to newest is 3, 2, 1
    invoice1 = create(:invoice, created_at: "Thu, 03 Feb 2022 01:13:46 UTC +00:00")
    invoice2 = create(:invoice, created_at: "Wed, 02 Feb 2022 01:13:46 UTC +00:00")
    invoice3 = create(:invoice, created_at: "Tue, 01 Feb 2022 01:13:46 UTC +00:00")

    no_show_invoice = create(:invoice)

    ii1 = create(:invoice_item, item: item1, invoice: invoice1)
    ii2 = create(:invoice_item, item: item1, invoice: invoice2)
    ii3 = create(:invoice_item, item: item1, invoice: invoice3)

    dont_display = create(:invoice_item, item: item1, status: "shipped", invoice: no_show_invoice)

    oldest = "Invoice Number: #{invoice3.id}"
    middle = "Invoice Number: #{invoice2.id}"
    newest = "Invoice Number: #{invoice1.id}"

    visit "/merchants/#{@merchant1.id}"
    expect(oldest).to appear_before(middle)
    expect(middle).to appear_before(newest)
    expect(page).not_to have_content(no_show_invoice.id)
  end

  it 'Favorite Customers section' do
    ## merchant 1 is the protagonist of the test! Death to all other merchants!!!!!!!!!!!
    merchant1 = Merchant.create!(name: "The Tornado", status: 1)
    item1 = merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    ## 1 Transaction - should not rank
    customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    invoice1 = customer1.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    ## 7 Transactions on 1 invoice // The #1 favorite
    customer2 = Customer.create!(first_name: "Narky", last_name: "Nark" )
    invoice1 = customer2.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    ## 2 Transactions over 2 invoices // The #5 favorite
    customer3 = Customer.create!(first_name: "Varky", last_name: "Vark" )
    invoice1 = customer3.invoices.create!(status: 0)
    invoice2 = customer3.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
    ## 6 Transactions over 2 invoices, plus a bunch of transactions with another merchant // The #2 favorite
    customer4 = Customer.create!(first_name: "Sharky", last_name: "Shark" )
    invoice1 = customer4.invoices.create!(status: 0)
    invoice2 = customer4.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
    merchant2 = Merchant.create!(name: "The Tornado", status: 1)
    item2 = merchant2.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    invoice1 = customer4.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item2.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 7894542, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 3456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 34563456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 3645, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 345634566, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 65433333, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 9872334, result: 0, invoice_id: invoice1.id)
    ## 8 Transactions on 5 invoices, but 4 transactions fail /4 total/ The #3 favorite
    customer5 = Customer.create!(first_name: "Clarky", last_name: "Clark" )
    invoice1 = customer5.invoices.create!(status: 0)
    invoice2 = customer5.invoices.create!(status: 0)
    invoice3 = customer5.invoices.create!(status: 0)
    invoice4 = customer5.invoices.create!(status: 0)
    invoice5 = customer5.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice3.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice4.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice5.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice2.id)
    Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice2.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice3.id)
    Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice4.id)
    Transaction.create!(credit_card_number: 123456, result: 1, invoice_id: invoice4.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice5.id)
    ## 1 Transaction for the merchant, 1 for another merchant (doesn't count), 2 transactions on a shared invoice between them (should count) /3 total/ The #4 favorite
    customer6 = Customer.create!(first_name: "Barky", last_name: "Bark" )
    merchant2 = Merchant.create!(name: "The Tornado", status: 1)
    item2 = merchant2.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    invoice1 = customer6.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    invoice2 = customer6.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item2.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
    invoice3 = customer6.invoices.create!(status: 0)
    InvoiceItem.create!(invoice_id: invoice3.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice3.id, item_id: item2.id, quantity: 2, unit_price: 2000, status: 0)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice3.id)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice3.id)

    visit "/merchants/#{merchant1.id}"

    within("#favorite-customer-1") do
      expect(page).to have_content(customer2.first_name)
      expect(page).to have_content(customer2.last_name)
      expect(page).to have_content("7 successful transactions")
    end

    within("#favorite-customer-2") do
      expect(page).to have_content(customer4.first_name)
      expect(page).to have_content(customer4.last_name)
      expect(page).to have_content("6 successful transactions")
    end

    within("#favorite-customer-3") do
      expect(page).to have_content(customer5.first_name)
      expect(page).to have_content(customer5.last_name)
      expect(page).to have_content("4 successful transactions")
    end

    within("#favorite-customer-4") do
      expect(page).to have_content(customer6.first_name)
      expect(page).to have_content(customer6.last_name)
      expect(page).to have_content("3 successful transactions")
    end

    within("#favorite-customer-5") do
      expect(page).to have_content(customer3.first_name)
      expect(page).to have_content(customer3.last_name)
      expect(page).to have_content("2 successful transactions")
    end

    expect(page).to_not have_content(customer1.first_name)
    expect(page).to_not have_content(customer1.last_name)
    expect(page).to_not have_content("1 successful transactions")
  end
end
