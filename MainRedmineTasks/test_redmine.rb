require 'selenium-webdriver'
require 'test-unit'
require_relative 'common_methods'

class TestRedmine < Test::Unit::TestCase

  include CommonMethods

  def setup
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout=>10)

    @login = get_random_login
    @password1 = 'Qwerty123!'
    @password2 = 'Qwerty123?'
  end

  def test_registration_successful
    register_new_user(@login, @password1)

    success_text = 'Your account has been activated. You can now log in.'
    actual_text = @driver.find_element(:id, 'flash_notice').text

    assert_equal(success_text, actual_text)
  end

  def test_can_logout
    register_new_user(@login, @password1)
    log_out

    assert(@driver.find_element(:class, 'login').displayed?, 'Login button is not displayed after logout.')
  end

  def test_can_login
    register_new_user(@login, @password1)
    log_out
    log_in(@login, @password1)

    logged_in_user = @driver.find_element(:css, '#loggedas .user.active').text

    assert_equal(@login, logged_in_user, 'Logged in user is not displayed as active.')
  end

  def test_password_change
    register_new_user(@login, @password1)
    change_password(@password1, @password2)

    success_text = 'Пароль успішно оновлений.'
    actual_text = @driver.find_element(:id, 'flash_notice').text

    assert_equal(success_text, actual_text)
  end

  def test_can_login_new_password
    register_new_user(@login, @password1)
    change_password(@password1, @password2)
    log_out
    log_in(@login, @password2)

    logged_in_user = @driver.find_element(:css, '#loggedas .user.active').text

    assert_equal(@login, logged_in_user, 'Logged in user is not displayed as active after password change.')
  end

  def test_can_create_new_project
    register_new_user(@login, @password1)
    create_new_project

    success_text='Створення успішно завершене.'
    actual_text = @driver.find_element(:id, 'flash_notice').text

    assert_equal(success_text, actual_text)
  end

  def test_create_project_version
    register_new_user(@login, @password1)
    create_new_project
    create_project_version

    success_text='Створення успішно завершене.'
    actual_text = @driver.find_element(:id, 'flash_notice').text

    assert_equal(success_text, actual_text)
  end

  def test_can_create_new_bug
    issue_type = 'Bug'

    register_new_user(@login, @password1)
    project_name = create_new_project
    navigate_to_project(project_name)
    issue_id = create_new_issue(issue_type)

    @driver.find_element(:css, 'a.issues').click
    @wait.until{@driver.find_element(:css, '.list.issues').displayed?}

    created_issue = @driver.find_element(:id, 'issue-'+issue_id.to_s)
    created_issue_type = created_issue.find_element(:class, 'tracker').text

    assert_equal(issue_type, created_issue_type,
                 'Type of created issue does not match the type selected during creation')
    end

  def test_can_create_new_feature
    issue_type = 'Feature'

    register_new_user(@login, @password1)
    project_name = create_new_project
    navigate_to_project(project_name)
    issue_id = create_new_issue(issue_type)

    @driver.find_element(:css, 'a.issues').click
    @wait.until{@driver.find_element(:css, '.list.issues').displayed?}

    created_issue = @driver.find_element(:id, 'issue-'+issue_id.to_s)
    created_issue_type = created_issue.find_element(:class, 'tracker').text

    assert_equal(issue_type, created_issue_type,
                 'Type of created issue does not match the type selected during creation')
  end

  def test_can_create_new_support
    issue_type = 'Support'

    register_new_user(@login, @password1)
    project_name = create_new_project
    navigate_to_project(project_name)
    issue_id = create_new_issue(issue_type)

    @driver.find_element(:css, 'a.issues').click
    @wait.until{@driver.find_element(:css, '.list.issues').displayed?}

    created_issue = @driver.find_element(:id, 'issue-'+issue_id.to_s)
    created_issue_type = created_issue.find_element(:class, 'tracker').text

    assert_equal(issue_type, created_issue_type,
                 'Type of created issue does not match the type selected during creation')
  end

  def teardown
    @driver.quit
  end
end