module SystemAuthenticationHelpers
  def log_in(user, password: "password")
    visit login_path

    fill_in User.human_attribute_name(:email),
      with: user.email
    fill_in User.human_attribute_name(:password),
      with: password

    click_button I18n.t("sessions.new.submit")
    assert_current_path root_path
  end
end
