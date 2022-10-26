require 'rails_helper'

RSpec.describe "User Registration" do
  it 'can create a user with a name and unique email' do
    visit register_path

    fill_in :user_name, with: 'User One'
    fill_in :user_email, with:'user1@example.com'
    fill_in 'Password:', with: 'Test'
    fill_in 'Password Confirmation:', with: 'Test'
    
    click_button 'Create New User'

    expect(current_path).to eq(user_path(User.last.id))
    expect(page).to have_content("User One's Dashboard")
  end 

  it 'does not create a user if email isnt unique' do 
    User.create(name: 'User One', email: 'notunique@example.com', password: 'Test')

    visit register_path
    
    fill_in :user_name, with: 'User Two'
    fill_in :user_email, with:'notunique@example.com'
    fill_in 'Password:', with: 'Test1'
    fill_in 'Password Confirmation:', with: 'Test1'

    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Email has already been taken")
    
  end

  describe "As a visitor when I visit `/register`" do
    describe "I see a form to fill in my name, email, password, and password confirmation." do
      it "When I fill in that form with my name, email, and matching passwords, I'm taken to my dashboard page `/users/:id`" do
        visit register_path

        fill_in :user_name, with: 'User Two'
        fill_in :user_email, with:'notunique@example.com'
        fill_in 'Password:', with: 'Test'
        fill_in 'Password Confirmation:', with: 'Test'

        click_button 'Create New User'

        expect(current_path).to eq(user_path(User.last.id))
        expect(page).to have_content("Welcome, User Two!")
      end
    end
  end

  describe "As a visitor when I visit `/register`" do
    describe "and I fail to fill in my name" do
      it "I'm taken back to the `/register` page and a flash message pops up, telling me what went wrong" do
        visit register_path

        fill_in :user_name, with: ''
        fill_in :user_email, with:'notunique@example.com'
        fill_in 'Password:', with: 'Test'
        fill_in 'Password Confirmation:', with: 'Test'

        click_button 'Create New User'

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Name can't be blank")
      end
    end
  end

  describe "As a visitor when I visit `/register`" do
    describe "and I fail to fill in a unique email" do
      it "I'm taken back to the `/register` page and a flash message pops up, telling me what went wrong" do
        User.create(name: 'User Two', email: 'notunique@example.com', password: 'Test')
        visit register_path

        fill_in :user_name, with: 'User Two'
        fill_in :user_email, with:'notunique@example.com'
        fill_in 'Password:', with: 'Test'
        fill_in 'Password Confirmation:', with: 'Test'

        click_button 'Create New User'

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Email has already been taken")
      end
    end
  end

  describe "As a visitor when I visit `/register`" do
    describe "and I fail to fill matching passwords" do
      it "I'm taken back to the `/register` page and a flash message pops up, telling me what went wrong" do
        visit register_path

        fill_in :user_name, with: 'User Two'
        fill_in :user_email, with:'notunique@example.com'
        fill_in 'Password:', with: 'Test'
        fill_in 'Password Confirmation:', with: 'Test3'

        click_button 'Create New User'

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Password confirmation doesn't match Password")
      end
    end
  end
end
