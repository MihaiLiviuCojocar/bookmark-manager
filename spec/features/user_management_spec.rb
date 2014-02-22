require 'spec_helper'
require_relative '../helpers/session'

feature "User signs up" do

  include SessionHelpers

  # Strictly speaking, the tests that check the UI
  # (have_content, etc.) should be separate from the tests
  # that check what we have in the DB. The reason is that
  # you should test one thing at a time, whereas
  # by mixing the two we're testing both
  # the business logic and the views.
  #
  # However, let's not worry about this yet
  # to keep the example simple.


  scenario "when being logged out" do
    # lambda { sign_up }.should change(User, :count).by(1)
    count = User.count
    sign_up
    expect(User.count).to eq(count+1)
    expect(page).to have_content("Welcome, alice@example.com")
    expect(User.first.email).to eq("alice@example.com")
  end

  scenario "with a password that doesn't match" do
    expect(User.count).to eq(0)
    sign_up('a@a.com', 'orange', '')
    expect(User.count).to eq(0)
    expect(current_path).to eq('/users')
    expect(page).to have_content("Your passwords don't match")
  end

  scenario "with an email that is already registered" do
    expect(User.count).to eq(0)
    sign_up
    expect(User.count).to eq(1)
    sign_up
    expect(User.count).to eq(1)
    expect(page).to have_content("This email is already taken")
  end

end

feature "User sings in" do

  include SessionHelpers

  before(:each) do
    User.create(:email                 => "test@test.com" ,
                :password              => "test" ,
                :password_confirmation => "test" )
  end

  scenario "with correct credentials" do
    visit '/'
    expect(page).not_to have_content("Welcome, test@test.com")
    sign_in('test@test.com', 'test')
    expect(page).to have_content("Welcome, test@test.com")
  end

  scenario "with incorrect credentials" do
    visit '/'
    expect(page).not_to have_content('Welcome, test@test.com')
    sign_in('test@test.com', 'wrong')
    expect(page).not_to have_content('Welcome, test@test.com')
  end

end

feature "User signs out" do

  include SessionHelpers

  before(:each) do
    User.create(:email                 => "test@test.com" ,
                :password              => "test" ,
                :password_confirmation => "test")
  end

  scenario "while being signed in" do
    sign_in("test@test.com", "test")
    click_button "Sign out"
    expect(page).to have_content("Good bye!")
    expect(page).not_to have_content("Welcome, test@test.com")
  end

end






