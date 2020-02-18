class TransactionsController < ApplicationController

    def show  # something isnt right here
        user = User.find(params[:id])
        transactions = user.transactions
        # newTransaction = Transaction.addCurrentPrice(transactions)
        render json: transactions
    end

    def create
        client = IEX::Api::Client.new(
            publishable_token: ENV['IEX_API_PUBLISHABLE_TOKEN'],
            endpoint: 'https://sandbox.iexapis.com/v1'
        )
        user = User.find(params[:user])
        begin
            price = client.price(params[:ticker]).round(2)
        rescue IEX::Errors::SymbolNotFoundError
            render json: ["INVALID Symbol"]
        else 
            total = (price * params[:stock_amount].to_i).round(2)
            if price 
                    if user.wallet - total > 0
                    transaction = Transaction.new(user_id: params[:user], ticker: params[:ticker].upcase, stock_amount: params[:stock_amount], price: price, total: total)
                    # byebug
                    if transaction.save
                        user.update(wallet: user.wallet - total)
                        render json: transaction
                    else
                        render json: transaction.full_message
                    end
                else
                    render json: ["You don't have enough money"]
                end
            else
                render json: ["fetch exceeded please try again later"]
            end
        end
    end
end
