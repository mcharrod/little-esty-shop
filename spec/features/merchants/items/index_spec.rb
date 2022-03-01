require 'rails_helper'

RSpec.describe 'merchant item index', type: :feature do
  it 'displays all items' do
    merchant = create(:merchant)

    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)

    visit "/merchants/#{merchant.id}/items"

    expect(page).to have_content(item1.name)
    expect(page).to have_content(item2.name)
    expect(page).to have_content(item3.name)
  end

  it 'has links to each items show page' do
    merchant = create(:merchant)

    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)

    visit "/merchants/#{merchant.id}/items"

    within "#item-#{item2.id}" do
      click_button "View item"
    end

    expect(current_path).to eq("/merchants/#{merchant.id}/items/#{item2.id}")
  end

  it 'can toggle the status from the index page' do
    merchant = create(:merchant)

    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)

    visit "/merchants/#{merchant.id}/items"


    within "#item-#{item1.id}" do

      expect(item1.status).to eq("disabled")

      click_button "enable"
      item1.reload

      expect(item1.status).to eq("enabled")
      expect(page).to have_content("enabled")
    end

    expect(page).to have_content("Item status updated!")
  end

  it 'after toggling the item will display in the correct column.' do
    merchant = create(:merchant)

    item1 = create(:item, merchant: merchant)
    item2 = create(:item, merchant: merchant)
    item3 = create(:item, merchant: merchant)

    visit "/merchants/#{merchant.id}/items"
    within "#item-#{item1.id}" do
      expect(item1.status).to eq("disabled")

      click_button "enable"
      item1.reload
    end
    within("#enabled") do
      expect(item1.status).to eq("enabled")
      expect(page).to have_content("enabled")
    end

    within "#item-#{item2.id}" do
      expect(item2.status).to eq("disabled")
      click_button "enable"
      item2.reload
    end
    within("#enabled") do
      expect(item2.status).to eq("enabled")
    end
    expect(page).to have_content("Item status updated!")
  end


  it "Lists the top five selling items for the merchant" do
    merchant1 = Merchant.create!(name: "The Tornado")
    smart = merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    fun = merchant1.items.create!(name: "FunPants", description: "Cha + 20", unit_price: 2000)
    fit = merchant1.items.create!(name: "FitPants", description: "Con + 20", unit_price: 150)
    veiny = merchant1.items.create!(name: "VeinyShorts", description: "Str + 20", unit_price: 1400)
    socks = merchant1.items.create!(name: "SpringSocks", description: "DX + 20", unit_price: 375)
    under = merchant1.items.create!(name: "UnderRoos", description: "SNUG!", unit_price: 25)
    sun = merchant1.items.create!(name: "SunStoppers", description: "Eclipse ready!", unit_price: 50)

    customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )
    customer2 = Customer.create!(first_name: "Larky", last_name: "Lark" )
    customer3 = Customer.create!(first_name: "Sparky", last_name: "Spark" )
    customer4 = Customer.create!(first_name: "Farky", last_name: "Fark" )

    invoice1 = customer1.invoices.create!(status: 2, created_at: "2014-05-22")
    invoice2 = customer2.invoices.create!(status: 2, created_at: "2014-05-21")
    invoice3 = customer3.invoices.create!(status: 2, created_at: "2014-05-20")
    invoice4 = customer4.invoices.create!(status: 2, created_at: "2014-05-22")
    invoice5 = customer4.invoices.create!(status: 2, created_at: "2014-05-19")


    # fun pants has 4500 revenue (500 x 5) + 1000 + 1000
    invoice_item1 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: fun.id, quantity: 5, unit_price: 500, status: 0)
    invoice_item5 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: fun.id, quantity: 1, unit_price: 1000, status: 1)
    invoice_item8 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: fun.id, quantity: 1, unit_price: 1000, status: 1)

    # smart pants has 4400 revenue (2000 x 2) + (100 x 4)
    invoice_item2 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: smart.id, quantity: 2, unit_price: 2000, status: 0)
    invoice_item4 = InvoiceItem.create!(invoice_id: invoice2.id, item_id: smart.id, quantity: 4, unit_price: 100, status: 1)

    # veiny shorts has 1400 revenue
    invoice_item9 = InvoiceItem.create!(invoice_id: invoice1.id, item_id: veiny.id, quantity: 3, unit_price: 1400, status: 2)

    # sun stoppers has 700 revenue (100 x 7)
    invoice_item7 = InvoiceItem.create!(invoice_id: invoice3.id, item_id: sun.id, quantity: 7, unit_price: 100, status: 2)

    # fit pants has 500 revenue (100 x 5)
    invoice_item3 = InvoiceItem.create!(invoice_id: invoice5.id, item_id: fit.id, quantity: 5, unit_price: 100, status: 0)

    # under roos has 75 revenue (25 x 3)
    invoice_item6 = InvoiceItem.create!(invoice_id: invoice4.id, item_id: under.id, quantity: 3, unit_price: 25, status: 2)

    transaction1 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice1.id)
    transaction2 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice2.id)
    transaction3 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice3.id)
    transaction4 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice4.id)
    transaction5 = Transaction.create!(credit_card_number: 123456, result: 0, invoice_id: invoice5.id)

    visit "/merchants/#{merchant1.id}/items"
    within("#top-five") do

      expect("FunPants").to appear_before("SmartPants")
      expect("Revenue Generated: 4500").to appear_before("Revenue Generated: 4400")
      expect("SmartPants").to appear_before("VeinyShorts")
      expect("VeinyShorts").to appear_before("SunStoppers")
      expect("SunStoppers").to appear_before("FitPants")
      expect(page).to_not have_content("SpringSocks")
      expect(page).to_not have_content("UnderRoos")
      click_link("#{smart.name}")
      expect(current_path).to eq("/merchants/#{merchant1.id}/items/#{smart.id}")
    end
  end

end
