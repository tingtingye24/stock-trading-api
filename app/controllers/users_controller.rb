class UsersController < ApplicationController

    def show
        user = User.find(params[:id])
        render json: user
    end




    def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
            render json: user
        else
            render json: ["Incorrect Email or Password"]
        end
    end

    def signup
        user = User.new(name: params[:name], password: params[:password], email: params[:email])
        if user.save
            render json: user
        else
            render json: user.errors.full_messages
        end
    end


    def profilio 
        # byebug
        user = User.find(params[:id])
        transactions = user.transactions
        
        mergedStocks = User.profilioStock(transactions)
        keys = mergedStocks.keys
        if(transactions.length > 0 && mergedStocks[keys[-1]][:open_price] > 0)
            render json: mergedStocks
        else
            render json: {}
        end
    end
end
