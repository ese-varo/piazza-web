module AuthenticationHelpers
  def log_in(user, remember_me: "0", password: "password")
    post login_path, params: {
      user: {
        email: user.email,
        password: password,
        remember_me: remember_me
      }
    }
  end

  def log_out
    delete logout_path
  end
end
