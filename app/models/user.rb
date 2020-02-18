class User < ApplicationRecord
    has_secure_password
    has_many :transactions
    validates :name, :password_digest, :email, presence: true
    validates :email, uniqueness: true


    def self.profilioStock(transactions)
# byebug
        # client = IEX::Api::Client.new(
        #     publishable_token: ENV['IEX_API_PUBLISHABLE_TOKEN'],
        #     endpoint: 'https://sandbox.iexapis.com/'
        # )
        client = Alphavantage::Client.new key: ENV['ALPHA_API_KEY']
        
        # byebug
        obj= {}
        transactions.map do |transaction|
            stock = client.stock symbol: transaction.ticker
            # byebug
            stock_quote = stock.quote
            open_price = stock_quote.open.to_f.round(2)
            current_price = stock_quote.price.to_f.round(2)
            # byebug                
            
            if obj.keys.include?(transaction.ticker)
                obj[transaction.ticker][:stock_amount] = obj[transaction.ticker][:stock_amount] + transaction.stock_amount
                obj[transaction.ticker][:total] = (obj[transaction.ticker][:total] + (current_price * transaction.stock_amount)).round(2)
                obj[transaction.ticker][:price] = transaction.price
                obj[transaction.ticker][:current_price] = current_price
                if !obj[transaction.ticker][:open_price]
                    obj[transaction.ticker][:open_price] = open_price
                end
            else
                obj[transaction.ticker]= {stock_amount: transaction.stock_amount, total: (current_price * transaction.stock_amount).round(2) , open_price: open_price, current_price: current_price, price: transaction.price}
            end
        end
    
        
        return obj
    end

end
