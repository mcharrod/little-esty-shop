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

  it "US20" do
    # creating additional customers so that there are more than 5, so that some will have to be excluded from the "top customers" section
    customer5 = Customer.create!(first_name: "Varky", last_name: "Vark" )
    customer6 = Customer.create!(first_name: "Sharky", last_name: "Shark" )
    customer7 = Customer.create!(first_name: "Tarky", last_name: "Tark" )


    # below we are creating additional invoices with a "completed" status...
    # AND invoice_items with a "shipped" status...
    # using BOTH of them to define a "successful transaction"

    # @customer4 has 5 successful transactions (including one in the before :each above)
    invoice6 = @customer4.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice6.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)
    invoice7 = @customer4.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice7.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)
    invoice8 = @customer4.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice8.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)
    invoice9 = @customer4.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice9.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)

    # @customer1 has 4 successful transactions
    invoice10 = @customer1.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice10.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)
    invoice11 = @customer1.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice11.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)
    invoice12 = @customer1.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice12.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)
    invoice13 = @customer1.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice13.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)

    # customer5 has 3 successful transactions
    invoice14 = customer5.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice14.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)
    invoice15 = customer5.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice15.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)
    invoice16 = customer5.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice16.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)

    # @customer2 has 2 successful transactions
    invoice17 = @customer2.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice17.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)
    invoice18 = @customer2.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice18.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)

    # customer7 has 1 successful transaction
    invoice19 = customer7.invoices.create!(status: 2)
    InvoiceItem.create!(invoice_id: invoice19.id, item_id: @item2.id, quantity: 1, unit_price: 2000, status: 2)

    visit '/admin'

    within("#top-customers") do
      expect(page).to have_content("Top 5 Customers")
      expect(page).to have_content("1. #{@customer4.name}")
      expect(page).to have_content("2. #{@customer1.name}")
      expect(page).to have_content("3. #{customer5.name}")
      expect(page).to have_content("4. #{@customer2.name}")
      expect(page).to have_content("5. #{customer7.name}")

      expect(page).to_not have_content("#{@customer3.name}")
      expect(page).to_not have_content("#{customer6.name}")
    end
  end
end
