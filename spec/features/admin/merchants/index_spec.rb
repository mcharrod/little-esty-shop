require 'rails_helper'

RSpec.describe 'admin merchant index page', type: :feature do
  before do
    @merchant1 = create(:merchant)
    @merchant2 = create(:merchant)
    @merchant3 = create(:merchant)
    @merchant4 = create(:merchant)
    @merchant5 = create(:merchant)
  end

  it 'displays all merchant names' do
    visit '/admin/merchants'
    expect(page).to have_content(@merchant1.name)
    expect(page).to have_content(@merchant2.name)
    expect(page).to have_content(@merchant3.name)
  end

  it 'toggles the merchant status' do
    visit '/admin/merchants'

    within("#merchant-#{@merchant1.id}") do
      click_button("enable")
    end

    expect(current_path).to eq("/admin/merchants")

    within("#merchant-#{@merchant1.id}") do
      expect(page).to have_content("status: enabled")
      click_button("disable")
    end

    expect(current_path).to eq("/admin/merchants")
    expect(@merchant1.status).to eq("disabled")

    within("#merchant-#{@merchant1.id}") do
      expect(page).to have_content("status: disabled")
    end
  end

  it 'ranks the top 5 merchants, gives their total revenue earned and their best day' do
## Total Revenue: 8690 / rank: 4
    merchant1 = Merchant.create!(name: "The Tornado")
    item1 = merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    ## Day 1 (Friday) / Invoice 1 Revenue = 8450 BEST DAY!!!!!!!!
    invoice1 = customer1.invoices.create!(status: 0, created_at: "2012-03-09 20:54:52")
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 125, status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 3, unit_price: 1400, status: 2)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    ## Day 2 (Saturday) / Invoice 2 Revenue = 240
    invoice2 = customer1.invoices.create!(status: 0, created_at: "2012-03-10 20:54:52")
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 120, status: 1)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)

## Total Revenue: 4092 / rank: 5
    merchant2 = Merchant.create!(name: "The Bornado")
    item1 = merchant2.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    ## Day 1 (Friday) / Invoice 1 Revenue = 492
    invoice1 = customer1.invoices.create!(status: 0, created_at: "2012-03-09 20:54:52")
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 200, status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 12, status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 140, status: 2)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    ## Day 2 (Saturday) / Invoice 2 Revenue = 3600 BEST DAY!!!!!!!!
    invoice2 = customer1.invoices.create!(status: 0, created_at: "2012-03-10 20:54:52")
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 3, unit_price: 1200, status: 1)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)

## Total Revenue: 18802/ rank: 3
    merchant3 = Merchant.create!(name: "The Qornado")
    item1 = merchant3.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    ## Day 1 (Friday) / Invoice 1 Revenue = 1802
    invoice1 = customer1.invoices.create!(status: 0, created_at: "2012-03-09 20:54:52")
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 300, status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 102, status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 1400, status: 2)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    ## Day 2 (Saturday) / Invoice 2 Revenue = 15600 BEST DAY!!!!!!!!
    invoice2 = customer1.invoices.create!(status: 0, created_at: "2012-03-10 20:54:52")
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 3, unit_price: 5200, status: 1)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)

## Total Revenue: 33520 / rank: 1
    merchant4 = Merchant.create!(name: "The Stornado")
    item1 = merchant4.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    ## Day 1 (Friday) / Invoice 1 Revenue = 32020 BEST DAY!!!!!!!!!!!!!
    invoice1 = customer1.invoices.create!(status: 0, created_at: "2012-03-09 20:54:52")
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 3000, status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 1020, status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 14000, status: 2)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    ## Day 2 (Saturday) / Invoice 2 Revenue = 1500
    invoice2 = customer1.invoices.create!(status: 0, created_at: "2012-03-10 20:54:52")
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 3, unit_price: 500, status: 1)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)

## Total Revenue: 18290 / rank: 2
    merchant5 = Merchant.create!(name: "The Mornado")
    item1 = merchant5.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    ## Day 1 (Friday) / Invoice 1 Revenue = 3290
    invoice1 = customer1.invoices.create!(status: 0, created_at: "2012-03-09 20:54:52")
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 100, unit_price: 30, status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 10, status: 0)
    InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 140, status: 2)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    ## Day 2 (Saturday) / Invoice 2 Revenue = 15000 BEST DAY!!!!!!!!!!!!!
    invoice2 = customer1.invoices.create!(status: 0, created_at: "2012-03-10 20:54:52")
    InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 300, unit_price: 50, status: 1)
    Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)


    visit '/admin/merchants'
    within("#top-1-of-5") do
      expect(page).to have_button("#{merchant4.name}")
      expect(page).to have_content("CA$H earned: 33520")
      expect(page).to have_content("Best day: Friday, March 09, 2012")
    end

    within("#top-2-of-5") do
      expect(page).to have_button("#{merchant3.name}")
      expect(page).to have_content("CA$H earned: 18802")
      expect(page).to have_content("Best day: Saturday, March 10, 2012")
    end

    within("#top-3-of-5") do
      expect(page).to have_button("#{merchant5.name}")
      expect(page).to have_content("CA$H earned: 18290")
      expect(page).to have_content("Best day: Saturday, March 10, 2012")
    end

    within("#top-4-of-5") do
      expect(page).to have_button("#{merchant1.name}")
      expect(page).to have_content("CA$H earned: 8690")
      expect(page).to have_content("Best day: Friday, March 09, 2012")
    end

    within("#top-5-of-5") do
      expect(page).to have_button("#{merchant2.name}")
      expect(page).to have_content("CA$H earned: 4092")
      expect(page).to have_content("Best day: Saturday, March 10, 2012")
    end
  end

  it "lists the top five merchants" do
    ## Total Revenue: 8690 / rank: 4
        merchant1 = Merchant.create!(name: "The Tornado")
        item1 = merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
        customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
        ## Day 1 (Friday) / Invoice 1 Revenue = 8450 BEST DAY!!!!!!!!
        invoice1 = customer1.invoices.create!(status: 0, created_at: "2012-03-09 20:54:52")
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 2000, status: 0)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 125, status: 0)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 3, unit_price: 1400, status: 2)
        Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
        ## Day 2 (Saturday) / Invoice 2 Revenue = 240
        invoice2 = customer1.invoices.create!(status: 0, created_at: "2012-03-10 20:54:52")
        InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 2, unit_price: 120, status: 1)
        Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)

    ## Total Revenue: 4092 / rank: 5
        merchant2 = Merchant.create!(name: "The Bornado")
        item1 = merchant2.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
        customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
        ## Day 1 (Friday) / Invoice 1 Revenue = 492
        invoice1 = customer1.invoices.create!(status: 0, created_at: "2012-03-09 20:54:52")
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 200, status: 0)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 12, status: 0)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 140, status: 2)
        Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
        ## Day 2 (Saturday) / Invoice 2 Revenue = 3600 BEST DAY!!!!!!!!
        invoice2 = customer1.invoices.create!(status: 0, created_at: "2012-03-10 20:54:52")
        InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 3, unit_price: 1200, status: 1)
        Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)

    ## Total Revenue: 18802/ rank: 3
        merchant3 = Merchant.create!(name: "The Qornado")
        item1 = merchant3.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
        customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
        ## Day 1 (Friday) / Invoice 1 Revenue = 1802
        invoice1 = customer1.invoices.create!(status: 0, created_at: "2012-03-09 20:54:52")
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 300, status: 0)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 102, status: 0)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 1400, status: 2)
        Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
        ## Day 2 (Saturday) / Invoice 2 Revenue = 15600 BEST DAY!!!!!!!!
        invoice2 = customer1.invoices.create!(status: 0, created_at: "2012-03-10 20:54:52")
        InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 3, unit_price: 5200, status: 1)
        Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)

    ## Total Revenue: 33520 / rank: 1
        merchant4 = Merchant.create!(name: "The Stornado")
        item1 = merchant4.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
        customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
        ## Day 1 (Friday) / Invoice 1 Revenue = 32020 BEST DAY!!!!!!!!!!!!!
        invoice1 = customer1.invoices.create!(status: 0, created_at: "2012-03-09 20:54:52")
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 3000, status: 0)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 1020, status: 0)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 14000, status: 2)
        Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
        ## Day 2 (Saturday) / Invoice 2 Revenue = 1500
        invoice2 = customer1.invoices.create!(status: 0, created_at: "2012-03-10 20:54:52")
        InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 3, unit_price: 500, status: 1)
        Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)

    ## Total Revenue: 18290 / rank: 2
        merchant5 = Merchant.create!(name: "The Mornado")
        item1 = merchant5.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
        customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
        ## Day 1 (Friday) / Invoice 1 Revenue = 3290
        invoice1 = customer1.invoices.create!(status: 0, created_at: "2012-03-09 20:54:52")
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 100, unit_price: 30, status: 0)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 1, unit_price: 10, status: 0)
        InvoiceItem.create!(invoice_id: invoice1.id, item_id: item1.id, quantity: 2, unit_price: 140, status: 2)
        Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
        ## Day 2 (Saturday) / Invoice 2 Revenue = 15000 BEST DAY!!!!!!!!!!!!!
        invoice2 = customer1.invoices.create!(status: 0, created_at: "2012-03-10 20:54:52")
        InvoiceItem.create!(invoice_id: invoice2.id, item_id: item1.id, quantity: 300, unit_price: 50, status: 1)
        Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
    visit '/admin/merchants'
    within("#top-5") do

      expect("33520").to appear_before("18802")
      expect("18802").to appear_before("18290")
      expect("18290").to appear_before("8690")
      expect("8690").to appear_before("4092")
      expect("The Stornado").to appear_before("The Qornado")
      expect("The Qornado").to appear_before("The Mornado")
      expect("The Mornado").to appear_before("The Tornado")
      expect("The Tornado").to appear_before("The Bornado")
    end
  end
end
