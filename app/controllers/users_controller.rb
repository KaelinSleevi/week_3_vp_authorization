class UsersController < ApplicationController 
    def new 
        @user = User.new()
    end 

    def show 
        @user = User.find(params[:id])
    end 

    def create 
        user = User.create(user_params)
        user[:email] = user[:email].downcase
        if user.save 
            redirect_to user_path(user)
            flash[:success] = "Welcome, #{user.name}!"
        else  
            flash[:error] = user.errors.full_messages.to_sentence
            redirect_to register_path
        end 
    end 

    private 

    def user_params 
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end 
end 