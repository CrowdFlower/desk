describe Desk::Client do
  context ".new" do
    before do
      @client = Desk::Client.new(:subdomain => "example", :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
    end

    describe ".macros" do

      context "lookup" do

        before do
          stub_get("macros").
            to_return(:body => fixture("macros.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.macros
          a_get("macros").
            should have_been_made
        end

        it "should return up to 100 macros worth of extended information" do
          macros = @client.macros

          macros.results.should be_a Array
          macros.results.first.macro.id.should == 11
        end

      end
    end

    describe ".macro" do

      context "lookup" do

        before do
          stub_get("macros/13").
            to_return(:body => fixture("macro.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.macro(13)
          a_get("macros/13").
            should have_been_made
        end

        it "should return up to 100 cases worth of extended information" do
          macro = @client.macro(13)

          macro.id.should == 13
          macro.name.should == "API Macro"
        end

      end
    end

    describe ".create_macro" do

      context "create" do

        before do
          stub_post("macros").
            to_return(:body => fixture("macro_create.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should post to the correct resource" do
          @client.create_macro("API Macro", :description => "Everything belongs here")
          a_post("macros").
            should have_been_made
        end

        it "should return the new macro" do
          macro = @client.create_macro("API Macro", :description => "Everything belongs here")

          macro.id.should == 12
          macro.name.should == "API Macro"
        end

      end
    end

    describe ".update_macro" do

      context "update" do

        before do
          stub_put("macros/13").
            to_return(:body => fixture("macro_update.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should post to the correct resource" do
          @client.update_macro(13, :name => "Updated")
          a_put("macros/13").
            should have_been_made
        end

        it "should return the new macro" do
          macro = @client.update_macro(13, :name => "Updated")

          macro.name.should == "Updated"
        end

      end
    end

    describe ".delete_macro" do

      context "delete" do

        before do
          stub_delete("macros/1").
            to_return(:body => fixture("macro_destroy.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should post to the correct resource" do
          @client.delete_macro(1)
          a_delete("macros/1").
            should have_been_made
        end

        it "should return a successful response" do
          macro = @client.delete_macro(1)
          macro.success.should == true
        end

      end
    end

    describe ".macro_actions" do

      context "lookup" do

        before do
          stub_get("macros/1/actions").
            to_return(:body => fixture("macro_actions.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.macro_actions(1)
          a_get("macros/1/actions").
            should have_been_made
        end

        it "should return up to 100 macro actions worth of extended information" do
          macro_actions = @client.macro_actions(1)

          macro_actions.should be_a Array
          macro_actions.first.action.slug.should == "set-case-description"
        end

      end
    end

    describe ".macro_action" do

      context "lookup" do

        before do
          stub_get("macros/1/actions/set-case-description").
            to_return(:body => fixture("macro_action.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.macro_action(1,"set-case-description")
          a_get("macros/1/actions/set-case-description").
            should have_been_made
        end

        it "should return up to 100 macro actions worth of extended information" do
          macro_action = @client.macro_action(1,"set-case-description")
          macro_action.slug.should == "set-case-description"
        end

      end
    end

    describe ".update_macro_action" do

      context "update" do

        before do
          stub_put("macros/1/actions/set-case-description").
            to_return(:body => fixture("macro_action_update.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should post to the correct resource" do
          @client.update_macro_action(1, "set-case-description", :value => "This is my case description")
          a_put("macros/1/actions/set-case-description").
            should have_been_made
        end

        it "should return the new macro" do
          macro_action = @client.update_macro_action(1, "set-case-description", :value => "This is my case description")
          macro_action.value.should == "Description to be applied"
        end

      end
    end
  end
end
