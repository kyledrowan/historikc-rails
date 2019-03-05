# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    ENV['AUTH0_CLIENT_ID'],
    ENV['AUTH0_CLIENT_SECRET'],
    'historikc.auth0.com',
    callback_path: '/auth/oauth2/callback',
    authorize_params: {
      scope: 'openid profile',
    },
  )
end
