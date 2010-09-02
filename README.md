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
