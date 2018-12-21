module SignInAs
  def sign_in_as(user = FactoryBot.create(:user))
    token = sign_in user
    yield token
  end
end
