require 'rails_helper'


RSpec.describe 'admin_invoices', type: :feature do

  before do

    @merchant1 = Merchant.create!(name: "The Tornado")
    @item1 = @merchant1.items.create!(name: "SmartPants", description: "IQ + 20", unit_price: 125)
    @customer1 = Customer.create!(first_name: "Marky", last_name: "Mark" )

    @invoice1 = @customer1.invoices.create!(status: 1)
    @invoice_item1 = InvoiceItem.create!(invoice_id: @invoice1.id, item_id: @item1.id, quantity: 2, unit_price: 125, status: 1)
  end


  it "Admin has an invoice index page." do
    visit "/admin/invoices"

    expect(page).to have_content("Invoice Number: #{@invoice1.id}")
    expect(page).to have_content("Invoice Number: #{@invoice2.id}")
    expect(page).to have_content("Invoice Number: #{@invoice3.id}")

  it "has a link to the invoice show page" do
    visit "/admin/invoices"

    click_link("Invoice Number: #{@invoice1.id}")
    expect(current_path).to eq("/admin/invoices/#{@invoice1.id}")
  end
end
