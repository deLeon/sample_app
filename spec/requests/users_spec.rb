require 'spec_helper'

describe "Users" do

  describe "signup" do

    describe "failure" do
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",           :with  => ""
          fill_in "Email",          :with  => ""
          fill_in "Password",       :with  => ""
          fill_in "Confirmation",   :with  => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end

    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",           :with  => "Example User"
          fill_in "Email",          :with  => "user@example.com"
          fill_in "Password",       :with  => "foobar"
          fill_in "Confirmation",   :with  => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end

  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in :email,     :with => ""
        fill_in :password,  :with => ""
        click_button
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        integration_sign_in(user)
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end
  end

  describe 'sidebar content' do

    before(:each) do
      user = Factory(:user)
      visit signin_path
      fill_in :email,     :with => user.email
      fill_in :password,  :with => user.password
      click_button
    end

    it 'should have 0 microposts' do
      visit root_path
      response.should_not have_selector("span.microposts", :content => "1 micropost")
    end

    it 'should have 1 micropost' do
      mp1 = "Lorem ipsum dolor sit amet"
      visit root_path
      fill_in :micropost_content, :with => mp1
      click_button
      response.should have_selector("span.microposts", :content => "1 micropost")
    end

    it 'should have 2 microposts' do
      mp1 = "Lorem ipsum dolor sit amet"
      mp2 = "Lorem ipsum"
      visit root_path
      fill_in :micropost_content, :with => mp1
      click_button
      fill_in :micropost_content, :with => mp2
      click_button
      response.should have_selector("span.microposts", :content => "2 microposts")
    end
  end
end

