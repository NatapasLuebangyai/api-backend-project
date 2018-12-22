module ApiSignIn
  def api_sign_in(user = FactoryBot.create(:user))
    token = Doorkeeper::AccessToken.create!(resource_owner_id: user.id)
    allow(controller).to receive(:doorkeeper_token) {token}
    yield token
  end
end
