Rails.application.config.middleware.use OmniAuth::Builder do
  provider :square, Settings.square.app.id, Settings.square.app.secret, scope: Settings.square.app.scope
end