require 'rails_helper'

RSpec.describe 'Landing Page' do
    before :each do 
        @user1 = User.create(name: "User One", email: "user1@test.com", password: "Test")
        @user2 = User.create(name: "User Two", email: "user2@test.com", password: "Test")
        visit '/'
    end 

    it 'has a header' do
        expect(page).to have_content('Viewing Party Lite')
    end

    it 'has links/buttons that link to correct pages' do 
        click_button "Create New User"
        
        expect(current_path).to eq(register_path) 
        
        visit '/'

        click_link "Home"
        expect(current_path).to eq(root_path)
    end 

    it 'lists out existing users' do 
        user1 = User.create(name: "User One", email: "user1@test.com", password: "Test")
        user2 = User.create(name: "User Two", email: "user2@test.com", password: "Test")

        expect(page).to have_content('Existing Users:')

        within('.existing-users') do 
            expect(page).to have_content(user1.email)
            expect(page).to have_content(user2.email)
        end     

    end

    describe "As a registered user when I visit the landing page `/`" do
        describe "I see a link for 'Log In' when I click on 'Log In'" do
            describe "I'm taken to a Log In page ('/login') where I can input my unique email and password." do
                it "when I enter my unique email and correct password, I'm taken to my dashboard page" do
                    expect(page).to have_link("Log In")
                    
                    click_link "Log In"
    
                    expect(current_path).to eq(login_path)
                
                    fill_in 'Username', with: @user1.user_name
                    fill_in 'Password', with: @user1.password
                
                    click_on "Submit"
                
                    expect(current_path).to eq(root_path)
                
                    expect(page).to have_content("Welcome, #{@user1.name}")
                end
            end
        end
    end
end
