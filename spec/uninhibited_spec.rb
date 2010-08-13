require 'spec_helper'

describe Uninhibited do
  def example_group
    RSpec::Core::ExampleGroup.describe 
  end
  subject { example_group }

  describe "#Feature" do
    it "is defined on Object" do
      Object.should respond_to("Feature")
    end

    it "delegates to describe" do
      block = proc {}
      should_receive(:describe).with("description", &block).and_return(example_group)
      Feature("description", &block)
    end
  end

  describe "#Scenario" do
    let(:feature) { Feature() }
    it "delegates to describe" do
      block = proc {}
      feature.should_receive(:describe).with("Scenario:", "description", &block)
      feature.Scenario("description", &block)
    end
  end

  describe "#Background" do
    let(:feature) { Feature() }
    it "delegates to describe" do
      feature.should_receive(:describe)
      feature.Background("description")
    end
  end

  describe "#Given" do
    let(:feature) { Feature() }
    it "delegates to example" do
      options, block = {}, proc {}
      feature.should_receive(:example).with("Given description", options, &block)
      feature.Given("description", options, &block)
    end
  end

  describe "#When" do
    let(:feature) { Feature() }
    it "delegates to example" do
      options, block = {}, proc {}
      feature.should_receive(:example).with("When description", options, &block)
      feature.When("description", options, &block)
    end
  end

  describe "#Then" do
    let(:feature) { Feature() }
    it "delegates to example" do
      options, block = {}, proc {}
      feature.should_receive(:example).with("Then description", options, &block)
      feature.Then("description", options, &block)
    end
  end

  describe "#And" do
    let(:feature) { Feature() }
    it "delegates to example" do
      options, block = {}, proc {}
      feature.should_receive(:example).with("And description", options, &block)
      feature.And("description", options, &block)
    end
  end

  describe "#But" do
    let(:feature) { Feature() }
    it "delegates to example" do
      options, block = {}, proc {}
      feature.should_receive(:example).with("But description", options, &block)
      feature.But("description", options, &block)
    end
  end

  context "integration" do
    let(:formatter) { Uninhibited::Formatter.new(nil) }

    subject { `rspec tmp/spec.rb` }
    before do
      File.open "tmp/spec.rb", "w" do |f|
        f.write(spec)
      end
    end
    after { File.unlink "tmp/spec.rb" }

    context "with no failures" do
      let(:spec) do
        <<-EOF
        require "spec_helper"
        Feature "User signs in" do
          Given "a successful step" do
            true.should be_true
          end
          Then "this should be successful" do
            true.should be_true
          end
        end
        EOF
      end

      it "prints the correct summary" do
        output = "2 examples (#{formatter.send(:red, "0 failures")})"
        should =~ Regexp.new(Regexp.escape(output))
      end
    end

    context "with a failure" do
      let(:spec) do
        <<-EOF
        require "spec_helper"
        Feature "User signs in" do
          Given "a successful step" do
            true.should be_true
          end
          Then "this should be successful" do
            true.should be_false
          end
        end
        EOF
      end

      it "prints the correct summary" do
        output = "2 examples (#{formatter.send(:red, "1 failure")})"
        should =~ Regexp.new(Regexp.escape(output))
      end
    end

    context "with a failure and dependent steps after it" do
      let(:spec) do
        <<-EOF
        require "spec_helper"
        Feature "User signs in" do
          Given "a successful step" do
            true.should be_true
          end
          Then "this should be successful" do
            true.should be_false
          end
          And "this shouldn't be run" do
            true.should be_true
          end
        end
        EOF
      end

      it "skips dependent steps" do
        should include(formatter.send(:cyan, "  And this shouldn't be run"))
      end

      it "prints the correct summary" do
        failures = formatter.send(:red, "1 failure")
        skipped = formatter.send(:cyan, "1 skipped")
        output = "3 examples (#{failures}, #{skipped})"
        should =~ Regexp.new(Regexp.escape(output))
      end
    end

    context "with background steps" do

      context "with a failure in the background step" do
        let(:spec) do
          <<-EOF
          require "spec_helper"
          Feature "User signs in" do
            Background do
              Given "a failing step" do
                true.should be_false
              end
            end
            Scenario "success" do
              Given "a successful step" do
                true.should be_true
              end
              Then "this should be successful" do
                true.should be_true
              end
            end
          end
          EOF
        end

        it "skips dependent steps" do
          should include(formatter.send(:cyan, "    Given a successful step"))
          should include(formatter.send(:cyan, "    Then this should be successful"))
        end

        it "prints the correct summary" do
          failures = formatter.send(:red, "1 failure")
          skipped = formatter.send(:cyan, "2 skipped")
          output = "3 examples (#{failures}, #{skipped})"
          should =~ Regexp.new(Regexp.escape(output))
        end
      end

      context "when applying a filter" do
        subject { `rspec tmp/spec.rb -e 'a successful step'` }
        let(:spec) do
          <<-EOF
          require "spec_helper"
          Feature "User signs in" do
            Background do
              Given "success" do
                true.should be_true
              end
            end
            Scenario "success" do
              Given "a successful step" do
                true.should be_true
              end
              Then "this should be successful" do
                true.should be_true
              end
            end
          end
          EOF
        end

        it "prints the correct summary" do
          failures = formatter.send(:red, "0 failures")
          output = "2 examples (#{failures})"
          should =~ Regexp.new(Regexp.escape(output))
        end
      end

    end

  end
end
