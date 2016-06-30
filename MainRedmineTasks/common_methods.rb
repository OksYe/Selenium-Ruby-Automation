require 'selenium-webdriver'

def register_new_user (driver, login, password)
  wait = Selenium::WebDriver::Wait.new(:timeout=>10)
  home_page_url = 'http://demo.redmine.org/'

  driver.navigate.to (home_page_url)
  wait.until{driver.find_element(:class, 'register').displayed?}
  driver.find_element(:class, 'register').click
  wait.until{driver.find_element(:id, 'user_login').displayed?}

  driver.find_element(:id, 'user_login').send_keys(login)
  driver.find_element(:id, 'user_password').send_keys(password)
  driver.find_element(:id, 'user_password_confirmation').send_keys(password)
  driver.find_element(:id, 'user_firstname').send_keys(login+'FirstName')
  driver.find_element(:id, 'user_lastname').send_keys(login+'LastName')
  driver.find_element(:id, 'user_mail').send_keys(login+'@mail.mail')
  driver.find_element(:css, '#user_language option[value="uk"]').click

  driver.find_element(:name, 'commit').click
  wait.until{driver.find_element(:id, 'flash_notice').displayed?}
end

def log_in (driver, login, pass)
  wait = Selenium::WebDriver::Wait.new(:timeout=>10)

  driver.find_element(:class, 'login').click
  wait.until{driver.find_element(:id, 'username').displayed?}
  driver.find_element(:id, 'username').send_keys(login)
  driver.find_element(:id, 'password').send_keys(pass)
  driver.find_element(:name, 'login').click
end

def log_out (driver)
  wait = Selenium::WebDriver::Wait.new(:timeout=>10)

  driver.find_element(:class, 'logout').click
  wait.until{driver.find_element(:class, 'login').displayed?}
end

def change_password (driver, pass1, pass2)
  wait = Selenium::WebDriver::Wait.new(:timeout=>10)

  driver.find_element(:class, 'my-account').click
  driver.find_element(:css, '.icon.icon-passwd').click
  wait.until{driver.find_element(:id, 'password').displayed?}

  driver.find_element(:id, 'password').send_keys(pass1)
  driver.find_element(:id, 'new_password').send_keys(pass2)
  driver.find_element(:id, 'new_password_confirmation').send_keys(pass2)
  driver.find_element(:name, 'commit').click
  wait.until{driver.find_element(:id, 'flash_notice').displayed?}
end

def create_new_project (driver)
  wait = Selenium::WebDriver::Wait.new(:timeout=>10)

  driver.find_element(:css, 'a.projects').click
  wait.until{driver.find_element(:css, 'a.icon.icon-add').displayed?}
  driver.find_element(:css, 'a.icon.icon-add').click
  wait.until{driver.find_element(:css, 'input[type="submit"][name="commit"]').displayed?}

  driver.find_element(:css, '#project_name').send_keys(project_name = get_random_project_name)
  driver.find_element(:css, '#project_description').send_keys('Some description.')
  driver.find_element(:css, '#project_identifier').send_keys(get_random_project_identifier)
  driver.find_element(:css, 'input[type="submit"][name="commit"]').click
  wait.until{@driver.find_element(:id, 'flash_notice').displayed?}

  project_name
end

def navigate_to_project (driver, project_name)
  wait = Selenium::WebDriver::Wait.new(:timeout=>10)
  #project_url = 'projects/' + project_name.to_s.downcase

  driver.find_element(:css, '.user.active').click
  wait.until{driver.find_element(:css, 'a[href*="/projects/"]').displayed?}

  # have to add foreach for case with list of projects OR probably doesn't work at all
  project_link = driver.find_element(:css, 'a[href*="/projects/"]')
  project_link_name = driver.find_element(:css, 'a[href*="/projects/"]').text
  if project_link_name == project_name
    project_link.click
  end

  wait.until{driver.find_element(:css, 'a.overview').displayed?}
end

def create_project_version (driver)
  wait = Selenium::WebDriver::Wait.new(:timeout=>10)

  driver.find_element(:css, '.settings.selected').click
  wait.until{driver.find_element(:css, '#tab-info.selected').displayed?}
  driver.find_element(:css, '#tab-versions').click
  driver.find_element(:css, 'a.icon.icon-add[href*="versions"]').click

  driver.find_element(:css, '#version_name').send_keys(get_random_project_version)
  driver.find_element(:css, 'input[type="submit"][name="commit"]').click
  wait.until{@driver.find_element(:id, 'flash_notice').displayed?}
end

def create_new_issue (driver, issue_type)
  wait = Selenium::WebDriver::Wait.new(:timeout=>10)

  driver.find_element(:css, 'a.new-issue').click
  wait.until{driver.find_element(:css, 'a.new-issue.selected').displayed?}

  issue_types_dropdown_menu = driver.find_element(:css, 'select#issue_tracker_id')
  option = Selenium::WebDriver::Support::Select.new(issue_types_dropdown_menu)
  option.select_by(:text, issue_type)

  driver.find_element(:css, 'input#issue_subject').send_keys('Some ' + issue_type.to_s + ' topic.')

  driver.find_element(:css, 'input[type="submit"][name="commit"]').click
  wait.until{@driver.find_element(:id, 'flash_notice').displayed?}
end

def get_random_login
  random = Random.new
  'OksanaTestLogin'+random.rand(99999).to_s
end

def get_random_project_name
  random = Random.new
  'OksanaTestProject'+random.rand(999).to_s
end

def get_random_project_identifier
  random = Random.new
  'oksanatestprojectidentifier'+random.rand(99999).to_s
end

def get_random_project_version
  random = Random.new
  'OksanaTestProjectVersion'+random.rand(999).to_s
end