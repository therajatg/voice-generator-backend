Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # For simplicity, allow all. Change to your Vercel URL in production
    
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end