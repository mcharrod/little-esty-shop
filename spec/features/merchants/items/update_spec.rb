require 'rails_helper'

RSpec.describe 'Merchant item update', type: :feature do
  before do
    @merchant = create(:merchant)
    @item1 = create(:item, merchant: @merchant, name: "old name", description: "old description")
    @item2 = create(:item, merchant: @merchant)
  end

  it 'links to item update from item show page' do
    visit "/merchants/#{@merchant.id}/items/#{@item1.id}"

    click_link "Update item"
    expect(current_path).to eq("/merchants/#{@merchant.id}/items/#{@item1.id}/edit")
  end

  it 'has a form to update the item' do
    visit "/merchants/#{@merchant.id}/items/#{@item1.id}/edit"

    expect(page).to have_field('Item name', with: 'old name')
    expect(page).to have_field('Description', with: 'old description')

    fill_in 'Item name', with: 'new name'
    fill_in 'Description', with: 'new description'
    click_button 'Update item'

    expect(current_path).to eq("/merchants/#{@merchant.id}/items/#{@item1.id}")
    expect(page).to have_content("Item successfully updated!")
    expect(page).to have_content('new name')
    expect(page).to have_content('new description')
    expect(page).to have_content('Item successfully updated!')
  end

  it 'sad path - no update when all fields are left blank' do
    visit "/merchants/#{@merchant.id}/items/#{@item1.id}/edit"

    expect(page).to have_field('Item name', with: 'old name')
    expect(page).to have_field('Description', with: 'old description')

    fill_in 'Item name', with: ''
    fill_in 'Description', with: ''
    fill_in 'Unit price', with: ''

    click_button 'Update item'

    expect(current_path).to eq("/merchants/#{@merchant.id}/items/#{@item1.id}/edit")

    @item1.reload
    expect(@item1.name).to eq("old name")
    expect(@item1.description).to eq("old description")
    expect(page).to have_content("Error: Name can't be blank, Description can't be blank, Unit price can't be blank")
  end

  it 'sad path - no update when some fields are left blank' do
    visit "/merchants/#{@merchant.id}/items/#{@item1.id}/edit"

    expect(page).to have_field('Item name', with: 'old name')
    expect(page).to have_field('Description', with: 'old description')

    fill_in 'Item name', with: 'New Name!'
    fill_in 'Description', with: ''
    fill_in 'Unit price', with: '700'

    click_button 'Update item'

    expect(current_path).to eq("/merchants/#{@merchant.id}/items/#{@item1.id}/edit")
    expect(page).to have_content("Error: Description can't be blank")

    @item1.reload
    expect(@item1.name).to eq("old name")
    expect(@item1.description).to eq("old description")
  end

end
