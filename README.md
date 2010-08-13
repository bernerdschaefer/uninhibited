# Uninhibited

Inspired by [unencumbered](http://github.com/hashrocket/unencumbered),
Unhibited gives painless Cucumber-style syntax for RSpec integration tests.

Here's a sample feature in Uninhibited:

    require "spec_helper"

    Feature "User creates a vurl" do
      Scenario "creating" do
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
    end
