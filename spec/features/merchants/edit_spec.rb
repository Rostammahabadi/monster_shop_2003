require 'rails_helper'

RSpec.describe "As a Visitor" do
  describe "After visiting a merchants show page and clicking on updating that merchant" do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 11234)

    end
    it 'I can see prepopulated info on that user in the edit form' do
      visit "/merchants/#{@bike_shop.id}"
      click_on "Update Merchant"

      expect(page).to have_link(@bike_shop.name)
      expect(find_field('Name').value).to eq "Brian's Bike Shop"
      expect(find_field('Address').value).to eq '123 Bike Rd.'
      expect(find_field('City').value).to eq 'Richmond'
      expect(find_field('State').value).to eq 'VA'
      expect(find_field('Zip').value).to eq "11234"
    end

    it 'I can edit merchant info by filling in the form and clicking submit' do
      visit "/merchants/#{@bike_shop.id}"
      click_on "Update Merchant"

      fill_in 'Name', with: "Brian's Super Cool Bike Shop"
      fill_in 'Address', with: "1234 New Bike Rd."
      fill_in 'City', with: "Denver"
      fill_in 'State', with: "CO"
      fill_in 'Zip', with: 80204

      click_button "Update Merchant"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}")
      expect(page).to have_content("Brian's Super Cool Bike Shop")
      expect(page).to have_content("1234 New Bike Rd.\nDenver, CO 80204")
    end

    it 'I see a flash message if i dont fully complete form' do
      visit "/merchants/#{@bike_shop.id}"
      click_on "Update Merchant"

      fill_in 'Name', with: ""
      fill_in 'Address', with: "1234 New Bike Rd."
      fill_in 'City', with: ""
      fill_in 'State', with: "CO"
      fill_in 'Zip', with: 80204

      click_button "Update Merchant"

      expect(page).to have_content("Name can't be blank and City can't be blank")
      expect(page).to have_button("Update Merchant")
    end

    it "shows an edit button for the item which takes me to an update page" do
      employee = @bike_shop.users.create(name: "Employee user",
                                 address: "99 Working Hard Lane",
                                 city: "Los Angeles",
                                 state: "California",
                                 zip: "90210",
                                 email: "employee_email@gmail.com",
                                 password: "employee_password",
                                 role: 1)
       @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
       @pull_toy = @bike_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
       @dog_bone = @bike_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee)

      visit "/merchant/items"

      within ".item-#{@tire.id}" do
        expect(page).to have_content("Edit")
        click_on "Edit"
      end

      expect(current_path).to eq("/merchant/items/#{@tire.id}/edit")

    end

    it "allows me to update the information with a flash message" do
      employee = @bike_shop.users.create(name: "Employee user",
                                 address: "99 Working Hard Lane",
                                 city: "Los Angeles",
                                 state: "California",
                                 zip: "90210",
                                 email: "employee_email@gmail.com",
                                 password: "employee_password",
                                 role: 1)
       @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
       @pull_toy = @bike_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
       @dog_bone = @bike_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee)

      visit "/merchant/items"

      within ".item-#{@tire.id}" do
        click_on "Edit"
      end

      page.has_field?(:name, with: "#{@tire.name}")
      page.has_field?(:description, with: "#{@tire.description}")
      page.has_field?(:price, with: "#{@tire.price}")
      page.has_field?(:image, with: "#{@tire.image}")
      page.has_field?(:inventory, with: "#{@tire.inventory}")
      fill_in "name", with: "Test"
      fill_in :description, with: "This is amazing"

      click_on "Update Item"

      expect(current_path).to eq("/merchant/items")

      expect(page).to have_content("Test has been updated")
      expect(page).to have_content("Test")
    end

    it "allows the merchant to update items from all items" do
      employee = @bike_shop.users.create(name: "Employee user",
                                 address: "99 Working Hard Lane",
                                 city: "Los Angeles",
                                 state: "California",
                                 zip: "90210",
                                 email: "employee_email@gmail.com",
                                 password: "employee_password",
                                 role: 1)
       @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
       @pull_toy = @bike_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
       @dog_bone = @bike_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee)

      visit "/items/#{@tire.id}"

      expect(page).to have_content("Edit Item")
      click_on "Edit Item"

      page.has_field?(:name, with: "#{@tire.name}")
      page.has_field?(:description, with: "#{@tire.description}")
      page.has_field?(:price, with: "#{@tire.price}")
      page.has_field?(:image, with: "#{@tire.image}")
      page.has_field?(:inventory, with: "#{@tire.inventory}")

      fill_in "name", with: "Rostam"
      click_on "Update Item"
      expect(current_path).to eq("/items/#{@tire.id}")
      expect(page).to have_content("Rostam")
    end
    it "allows the image field to be blank and still show a default image" do
      employee = @bike_shop.users.create(name: "Employee user",
                                 address: "99 Working Hard Lane",
                                 city: "Los Angeles",
                                 state: "California",
                                 zip: "90210",
                                 email: "employee_email@gmail.com",
                                 password: "employee_password",
                                 role: 1)
       @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
       @pull_toy = @bike_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
       @dog_bone = @bike_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 20, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(employee)

      visit "/items/#{@tire.id}"


      click_on "Edit Item"

      fill_in "image", with: " "
      click_on "Update Item"
      expect(current_path).to eq("/items/#{@tire.id}")
      #will need to update to check if image is still present
    end


  end
end
