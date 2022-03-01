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

  it "lists the top five merchants" do
    merchant = Merchant.create!(name: "The Kornado")
    merchant1 = Merchant.create!(name: "The Tornado", status: 1)
    merchant3 = Merchant.create!(name: "The Mornado", status: 1)
    merchant2 = Merchant.create!(name: "The Vornado", status: 0)
    merchant4 = Merchant.create!(name: "The Lornado", status: 0)
    smart = merchant.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 120)
    fun = merchant1.items.create!(name: "FunPants", description: "Cha + 20", unit_price: 2000)
    fit = merchant2.items.create!(name: "FitPants", description: "Con + 20", unit_price: 150)
    veiny = merchant4.items.create!(name: "VeinyShorts", description: "Str + 20", unit_price: 1400)
    socks = merchant3.items.create!(name: "SpringSocks", description: "DX + 20", unit_price: 375)
    under = merchant2.items.create!(name: "UnderRoos", description: "SNUG!", unit_price: 25)
    sun = merchant3.items.create!(name: "SunStoppers", description: "Eclipse ready!", unit_price: 50)

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
    visit '/admin/merchants'
    within("#top-5") do
      expect(page).to have_content("CA$H earned: 12600")
      expect("12600").to appear_before("12400")
      expect("12400").to appear_before("11500")
      expect("1400").to appear_before("1075")
    end
  end
end
