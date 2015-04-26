require "spec_helper"

module UsersHelper
  def sign_in_user
    @user = create(:user)
    @user.confirm!
    click_link "Login"
    fill_in "Username", with: @user.username
    fill_in "Password", with: @user.password
    click_button "Sign in"
    page.should have_content "Signed in successfully"
  end
  
  def sign_in_user2
    @user2 = create(:user)
    @user2.confirm!
    click_link "Login"
    fill_in "Username", with: @user2.username
    fill_in "Password", with: @user2.password
    click_button "Sign in"
    page.should have_content "Signed in successfully"
  end
  
  def sign_in_standard_user
    @user3 = create(:user, role: "standard")
    @user3.confirm!
    click_link "Login"
    fill_in "Username", with: @user3.username
    fill_in "Password", with: @user3.password
    click_button "Sign in"
    page.should have_content "Signed in successfully"
  end
  
  def sign_out
    click_link "Logout"
    page.should have_content "Signed out successfully."
  end
end