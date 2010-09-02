# Uninhibited

Inspired by [unencumbered](http://github.com/hashrocket/unencumbered),
Unhibited gives painless Cucumber-style syntax for RSpec integration tests.

## Sample Feature
Here's a sample feature in Uninhibited:

    require "spec_helper"

    Feature "User creates a vurl" do
      Given "I am on the home page" do
        visit root_path
      end

      When "I submit a valid vurl" do
        fill_in "vurl_url", :with => 'http://example.com'
        click_button 'Vurlify!'
      end

      Then "I should be on the vurl stats page" do
        current_url.should == stats_url(Vurl.last.slug)
      end

      And "I should see a success message" do
        response.body.should include('Vurl was successfully created')
      end

      And "my vurl was created" do
        Vurl.last.url.should == 'http://example.com'
      end
    end

## Failing Steps
In rspec, when a step fails the rest of the suite continues to run.
Uninhibited, however, works like cucumber, and will skip steps after a failure.
You'll see rspec output something like this:

    !!!text
    Feature: User signs in
      Given I am on the home page
      When I click Sign in (FAILED - 1)
      Then I see a sign in form

    Failures:
      1) User signs in When I click Sign in
         Failure: no such link

    Finished in 0.00754 seconds
    3 examples (1 failure, 1 skipped)

## Background Steps
Uninhibited also allows you to define background steps, which will be run
before each scenario in a file:

    Feature "User signs up" do
      Background do
        Given "I am on the sign up page" do
          visit signup_page
        end
      end

      Scenario "success" do
        When "I fill in the form and submit it" do
          fill_in "Email", :with => "account@example.com"
          click_button "Sign up"
        end

        Then "I see a success message" do
          page.should have_content("Your account has been created")
        end

        And "I am on the home page" do
          current_path.should == root_path
        end
      end

      Scenario "failure" do
        When "I submit without the required fields" do
          click_button "Sign up"
        end

        Then "I see an error message" do
          page.should have_content("Your account could not be created")
        end
      end
    end

## Filtered execution
Again, like cucumber, Uninhibited is smart when you run a filtered command, such as:
`rspec spec/integration/user_signs_in_spec.rb:18` or `rspec
spec/integration/user_signs_in_spec -e "I see a success message"`. These will
run all dependent steps (both preceding steps and background steps) before
running the requested step.
