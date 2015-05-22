module AuthServices

  # Checks if there is an authentication for a user
  # - if it does not exist it creates the authentication and user
  class Authenticate
    # @param [Hash] auth_hash
    # @return [User]
    def call(auth_hash)
      auth = Authentication.find_or_initialize_by(uid: auth_hash[:uid], provider: auth_hash[:provider])
      unless auth.user
        user = User.new(
            name: auth_hash[:info][:name],
            nickname: auth_hash[:info][:nickname],
            email: auth_hash[:info][:email]
        )
        user.send("#{auth_hash[:provider]}_uid=", auth_hash[:uid])
        auth.update!(user: user)
      end
      auth.user
    end
  end
end