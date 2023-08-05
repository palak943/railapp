class PaymentController < ApplicationController
    def create
      @amount = 300 # Amount in cents, adjust as needed based on your pricing
  
      # Create a customer in Stripe (optional, you can skip this step if you don't need to store customer info)
      customer = Stripe::Customer.create(
        email: current_user.email,
        source: params[:stripeToken]
      )
  
      # Charge the customer using Stripe
      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: @amount,
        description: '3 articles per day',
        currency: 'usd'
      )
  
      # Check if the payment was successful
      if charge.paid
        # Update the user's post limit based on the subscription purchased
        current_user.update_post_limit(3) # Update with the appropriate limit based on the subscription
        redirect_to root_path, notice: "Payment successful. You can now view 3 articles per day."
      else
        redirect_to payment_failed_path, alert: "Payment failed. Please try again or contact support."
      end
    rescue Stripe::CardError => e
      redirect_to payment_failed_path, alert: e.message
    end
  
end
