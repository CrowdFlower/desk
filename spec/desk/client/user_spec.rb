describe Desk::Client do
  context ".new" do
    before do
      @client = Desk::Client.new(:subdomain => "example", :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
    end

    describe ".user" do

      context "with id passed" do

        before do
          stub_get("users/1").
            to_return(:body => fixture("user.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.user(1)
          a_get("users/1").
            should have_been_made
        end

        it "should return extended information of a given user" do
          user = @client.user(1)
          user.name.should == "Chris Warren"
        end

      end
    end

    describe ".users" do

      context "lookup" do

        before do
          stub_get("users").
            to_return(:body => fixture("users.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.users
          a_get("users").
            should have_been_made
        end

        it "should return up to 100 users worth of extended information" do
          users = @client.users
          users.results.should be_a Array
          users.results.first.user.name.should == "Test User"
        end

      end
    end
  end
end
