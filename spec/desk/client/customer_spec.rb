describe Desk::Client, "customers" do
  let(:client) do
    Desk::Client.new(:subdomain => "example", :consumer_key => 'CK', :consumer_secret => 'CS', :oauth_token => 'OT', :oauth_token_secret => 'OS')
  end

  describe ".customers" do
    let!(:request) do
      stub_get("customers").with(
        body: nil,
        headers: {
          "Accept" => "application/json"
        }
      ).to_return(
        body: fixture("customers.json"),
        headers: {
          content_type: "application/json; charset=utf-8"
        }
      )
    end

    it "return an array of customers" do
      customers = client.customers
      expect(request).to have_been_made

      expect(customers.results).to be_an(Array)
      expect(customers.results.first.customer.first_name).to eq("Jeremy")
    end
  end

  describe ".customer" do
    let!(:request) do
      stub_get("customers/1").with(
        headers: {
          "Accept" => "application/json"
        }
      ).to_return(
        body: fixture("customer.json"),
        headers: {
          content_type: "application/json; charset=utf-8"
        }
      )
    end

    it "returns customer info" do
      customer = client.customer(1)
      expect(request).to have_been_made

      expect(customer.first_name).to eq("John")
      expect(customer.addresses.first.value).to eq("123 Main St, San Francisco, CA 94105")
    end
  end

  describe ".create_customer" do
    let!(:request) do
      stub_post("customers").with(
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        },
        body: MultiJson.dump(params)
      ).to_return(
        body: fixture("customer_create.json"),
        headers: {
          content_type: "application/json; charset=utf-8"
        }
      )
    end

    let(:params) do
      {
        first_name: "John",
        last_name: "Doe"
      }
    end

    it "returns information about the customer" do
      customer = client.create_customer(params)
      expect(request).to have_been_made

      expect(customer.first_name).to eq("John")

    end
  end

  describe ".update_customer" do
    let!(:request) do
      stub_patch("customers/1").with(
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        },
        body: MultiJson.dump(params)
      ).to_return(
        body: fixture("customer_update.json"),
        headers: {
          :content_type => "application/json; charset=utf-8"
        }
      )
    end

    let(:params) do
      {
        first_name: "Chris",
        last_name: "Warren"
      }
    end

    it "should return the information about this user" do
      customer = client.update_customer(1, params)
      expect(request).to have_been_made
      expect(customer.first_name).to eq("Chris")
    end
  end
end
