Rails.configuration.stripe = {
  publishable_key: 'pk_test_51BTUDGJAJfZb9HEBwDg86TN1KNprHjkfipXmEDMb0gSCassK5T3ZfxsAbcgKVmAIXF7oZ6ItlZZbXO6idTHE67IM007EwQ4uN3',
  secret_key: 'sk_test_tR3PYbcVNZZ796tH88S4VQ2u'
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]