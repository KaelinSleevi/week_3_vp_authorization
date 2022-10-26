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
      end
    end
  end 
end
