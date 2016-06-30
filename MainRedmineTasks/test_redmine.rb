require 'selenium-webdriver'
require 'test-unit'
require_relative 'common_methods'

class TestRedmine < Test::Unit::TestCase

  def setup
    @driver = Selenium::WebDriver.for :firefox
    @wait = Selenium::WebDriver::Wait.new(:timeout=>10)
    @password1 = 'Qwerty123!'
    @password2 = 'Qwerty123?'
    @login = get_random_login
    @home_page_url = 'http://demo.redmine.org/'
  end

  def test_registration_successful
    register_new_user(@driver, @login, @password1)

    success_text = 'Your account has been activated. You can now log in.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_equal(success_text, actual_text)
  end

  def test_can_logout
    register_new_user(@driver, @login, @password1)
    log_out(@driver)

    assert_equal(@home_page_url, @driver.current_url, 'Logout did not redirect to home page')
    assert (@driver.find_element(:class, 'login').displayed?)
  end

  def test_can_login
    register_new_user(@driver, @login, @password1)
    log_out(@driver)
    log_in(@driver, @login, @password1)

    logged_in_user = @driver.find_element(:css, '#loggedas .user.active').text
    assert_equal(@login, logged_in_user)
    assert (@driver.find_element(:class, 'my-account').displayed?)
  end

  def test_password_change
    register_new_user(@driver, @login, @password1)
    log_out(@driver)
    log_in(@driver, @login, @password1)

    @driver.find_element(:class, 'my-account').click
    @driver.find_element(:css, '.icon.icon-passwd').click

    @driver.find_element(:id, 'password').send_keys(@password1)
    @driver.find_element(:id, 'new_password').send_keys(@password2)
    @driver.find_element(:id, 'new_password_confirmation').send_keys(@password2)

    @driver.find_element(:name, 'commit').click
    @wait.until{@driver.find_element(:id, 'flash_notice').displayed?}

    success_text = 'Пароль успішно оновлений.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_equal(success_text, actual_text)
  end

  def test_can_login_new_password
    register_new_user(@driver, @login, @password1)
    log_out(@driver)
    log_in(@driver, @login, @password1)
    change_password(@driver, @password1, @password2)
    log_out(@driver)
    log_in(@driver, @login, @password2)

    logged_in_user = @driver.find_element(:css, '#loggedas .user.active').text
    assert_equal(@login, logged_in_user)
    assert (@driver.find_element(:class, 'my-account').displayed?)
  end

  def test_can_create_new_project
    register_new_user(@driver, @login, @password1)
    create_new_project(@driver)

    success_text='Створення успішно завершене.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_equal(success_text, actual_text)
  end

  def test_create_project_version
    register_new_user(@driver, @login, @password1)
    create_new_project(@driver)
    create_project_version(@driver)

    success_text='Створення успішно завершене.'
    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_equal(success_text, actual_text)
  end

  def test_can_create_new_bug
    issue_type = 'Bug'

    register_new_user(@driver, @login, @password1)
    project_name = create_new_project(@driver)
    navigate_to_project(@driver, project_name)
    issue_id = create_new_issue(@driver, issue_type)

    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_true(actual_text.to_s.include?('Issue'))
    assert_true(actual_text.to_s.include?('created.'))
    assert_true(@driver.find_element(:css, 'div#content h2').text.to_s.include?(issue_type))
    assert_true(@driver.find_element(:css, 'div.subject h3').text.to_s.include?(issue_type))

    @driver.find_element(:css, 'a.issues').click
    created_issue_id = @driver.find_element(:css, 'table[class*="list issues"] tbody > *:first-child td.id').text
    created_issue_type = @driver.find_element(:css, 'table[class*="list issues"] tbody > *:first-child td.tracker').text

    assert_equal(issue_id, created_issue_id)
    assert_equal(issue_type, created_issue_type)
    end

  def test_can_create_new_feature
    issue_type = 'Feature'

    register_new_user(@driver, @login, @password1)
    project_name = create_new_project(@driver)
    navigate_to_project(@driver, project_name)
    issue_id = create_new_issue(@driver, issue_type)

    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_true(actual_text.to_s.include?('Issue'))
    assert_true(actual_text.to_s.include?('created.'))
    assert_true(@driver.find_element(:css, 'div#content h2').text.to_s.include?(issue_type))
    assert_true(@driver.find_element(:css, 'div.subject h3').text.to_s.include?(issue_type))

    @driver.find_element(:css, 'a.issues').click
    created_issue_id = @driver.find_element(:css, 'table[class*="list issues"] tbody > *:first-child td.id').text
    created_issue_type = @driver.find_element(:css, 'table[class*="list issues"] tbody > *:first-child td.tracker').text

    assert_equal(issue_id, created_issue_id)
    assert_equal(issue_type, created_issue_type)
  end

  def test_can_create_new_support
    issue_type = 'Support'

    register_new_user(@driver, @login, @password1)
    project_name = create_new_project(@driver)
    navigate_to_project(@driver, project_name)
    issue_id = create_new_issue(@driver, issue_type)

    actual_text = @driver.find_element(:id, 'flash_notice').text
    assert_true(actual_text.to_s.include?('Issue'))
    assert_true(actual_text.to_s.include?('created.'))
    assert_true(@driver.find_element(:css, 'div#content h2').text.to_s.include?(issue_type))
    assert_true(@driver.find_element(:css, 'div.subject h3').text.to_s.include?(issue_type))

    @driver.find_element(:css, 'a.issues').click
    created_issue_id = @driver.find_element(:css, 'table[class*="list issues"] tbody > *:first-child td.id').text
    created_issue_type = @driver.find_element(:css, 'table[class*="list issues"] tbody > *:first-child td.tracker').text

    assert_equal(issue_id, created_issue_id)
    assert_equal(issue_type, created_issue_type)
  end

  def teardown
    @driver.quit
  end
end