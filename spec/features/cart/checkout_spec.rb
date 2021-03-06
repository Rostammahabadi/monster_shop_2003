require 'rails_helper'

RSpec.describe 'Cart show page' do
  describe 'When I have added items to my cart' do
    before(:each) do
      default_user = User.create(name: "Natasha Romanoff",
        address: "890 Fifth Avenue",
        city: "Manhattan",
        state: "New York",
        zip: "10010",
        email: "spiderqueen@hotmail.com",
        password: "arrow",
        role: 0)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(default_user)
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
      @items_in_cart = [@paper,@tire,@pencil]
    end

    it 'Theres a link to checkout' do
      visit "/cart"

      expect(page).to have_link("Checkout")

      click_on "Checkout"

      expect(current_path).to eq("/orders/new")
    end

    it "I see a button next to each item that allows me to add one more of that item until item's inventory is reached" do

      visit "/cart"

      expect(page).to have_content("Cart: 3")

      within "#cart-item-#{@tire.id}" do
        click_button "Add one more.."
      end

      expect(page).to have_content("You've added one more #{@tire.name} to your cart")
      expect(page).to have_content("Cart: 4")

      within "#cart-item-#{@paper.id}" do
        click_button "Add one more.."
      end

      expect(page).to have_content("You've added one more #{@paper.name} to your cart")
      expect(page).to have_content("Cart: 5")

      within "#cart-item-#{@paper.id}" do
        click_button "Add one more.."
        expect(page).to_not have_button("Add one more..")
      end

    end

    it "I see a button next to each item that allows me to subtract one of that item until none are left in the cart" do

      visit "/cart"

      expect(page).to have_content("Cart: 3")

      within "#cart-item-#{@paper.id}" do
        click_button "Remove one.."
      end

      expect(page).to_not have_link("#{@paper.name}")
      expect(page).to have_link("#{@tire.name}")
      expect(page).to have_link("#{@pencil.name}")

    end
  end

  describe 'When I havent added items to my cart' do
    it 'There is not a link to checkout' do
      visit "/cart"

      expect(page).to_not have_link("Checkout")
    end
  end
end
