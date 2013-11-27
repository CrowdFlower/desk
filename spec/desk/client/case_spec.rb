describe Desk::Client do
  let(:client) do
    Desk::Client.new(
      :subdomain => "example",
      :consumer_key => 'CK',
      :consumer_secret => 'CS',
      :oauth_token => 'OT',
      :oauth_token_secret => 'OS'
    )
  end

  describe ".cases" do
    let!(:request) do
      stub_get("cases").with(
        headers: {
          "Accept" => "application/json"
        },
        body: nil
      ).to_return(
        :body => fixture("cases.json"),
        :headers => {
          :content_type => "application/json; charset=utf-8"
        }
      )
    end

    it "returns cases" do
      cases = client.cases
      expect(request).to have_been_made
      cases.results.should be_a Array
      cases.results.first.case.id.should == 1
      cases.results.first.case.user.name.should == "Jeremy Suriel"
    end
  end

  describe ".case" do
    let!(:request) do
      stub_get("cases/1").with(
        headers: {
          "Accept" => "application/json"
        },
        body: nil
      ).to_return(
        :body => fixture("case.json"),
        :headers => {:content_type => "application/json; charset=utf-8"}
      )
    end

    it "parses the information correctly" do
      kase = client.case(1)
      expect(request).to have_been_made
      expect(kase.subject).to eq("Welcome")
      expect(kase.custom_fields).to eq(
        {
          "level" => "vip"
        }
      )
    end
  end

  describe ".update_case" do
    let!(:request) do
      stub_patch("cases/1").with(
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        },
        body: MultiJson.dump(params)
      ).to_return(
        :body => fixture("case_update.json"),
        :headers => {:content_type => "application/json; charset=utf-8"}
      )
    end

    let(:params) do
      {
        subject: "Updated"
      }
    end

    it "updates the right information" do
      kase = client.update_case(1, params)
      expect(request).to have_been_made

      expect(kase.subject).to eq("Updated")
    end
  end

  describe ".case_url" do
    it "should make a correct url for the case" do
      client.case_url(123).should == "https://example.desk.com/agent/case/123"
    end
  end
end
