require "application_system_test_case"

module Mobile
  class NavigationBarTest < MobileSystemTestCase
    test "can access sign up page via burger menu" do
      visit_with_mobile_size(root_path)
      find(".navbar-burger").click
      click_on I18n.t("application.navbar.sign_up")

      assert_current_path sign_up_path
    end

    test "can access login page via burger menu" do
      visit_with_mobile_size(root_path)
      find(".navbar-burger").click
      click_on I18n.t("application.navbar.login")

      assert_current_path login_path
    end

    test "can logout via burger menu" do
      log_in(users(:jerry))
      visit_with_mobile_size(root_path)
      find(".navbar-burger").click
      click_on I18n.t("application.navbar.logout")

      assert_current_path root_path
      assert_selector ".notification",
        text: I18n.t("sessions.destroy.success")
    end
  end
end
