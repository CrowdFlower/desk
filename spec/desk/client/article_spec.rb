describe Desk::Client do
  context ".new" do
    before do
      @client = Desk::Client.new(:subdomain => "example", :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
    end

    describe ".articles" do

      context "lookup" do

        before do
          stub_get("topics/1/articles").
            to_return(:body => fixture("articles.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should post to the correct resource" do
          @client.articles(1)
          a_get("topics/1/articles").
            should have_been_made
        end

        it "should return the articles" do
          articles = @client.articles(1)

          articles.results.should be_a Array
          articles.results.first.article.id.should == 13
        end

      end
    end

    describe ".article" do

      context "lookup" do

        before do
          stub_get("articles/13").
            to_return(:body => fixture("article.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should get the correct resource" do
          @client.article(13)
          a_get("articles/13").
            should have_been_made
        end

        it "should return up to 100 cases worth of extended information" do
          article = @client.article(13)

          article.id.should == 13
          article.subject.should == "API Tips"
        end

      end
    end

    describe ".create_article" do

      context "create" do

        before do
          stub_post("topics/1/articles").
            to_return(:body => fixture("article_create.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should post to the correct resource" do
          @client.create_article(1, :subject => "API Tips", :main_content => "Tips on using our API")
          a_post("topics/1/articles").
            should have_been_made
        end

        it "should return the articles" do
          article = @client.create_article(1, :subject => "API Tips", :main_content => "Tips on using our API")

          article.id.should == 13
        end

      end
    end

    describe ".update_article" do

      context "update" do

        before do
          stub_put("articles/1").
            to_return(:body => fixture("article_update.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should post to the correct resource" do
          @client.update_article(1, :subject => "API Tips", :main_content => "Tips on using our API")
          a_put("articles/1").
            should have_been_made
        end

        it "should return the new topic" do
          topic = @client.update_article(1, :subject => "API Tips", :main_content => "Tips on using our API")

          topic.subject.should == "API Tips"
          topic.main_content.should == "Tips on using our API"
        end

      end
    end

    describe ".delete_article" do

      context "delete" do

        before do
          stub_delete("articles/1").
            to_return(:body => fixture("article_destroy.json"), :headers => {:content_type => "application/json; charset=utf-8"})
        end

        it "should post to the correct resource" do
          @client.delete_article(1)
          a_delete("articles/1").
            should have_been_made
        end

        it "should return a successful response" do
          topic = @client.delete_article(1)
          topic.success.should == true
        end

      end
    end

  end
end
