module Desk
  class Client
    # Defines methods related to customers
    module Customer
      # Returns extended information of customers
      #
      #   @option options [Boolean, String, Integer]
      #   @example Return extended information for customers
      #     Desk.customers
      #     Desk.customers(:since_id => 12345, :count => 5)
      # @authenticated true
      # @see http://dev.desk.com/docs/api/customers
      def customers(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        response = get("customers",options)
        response
      end

      # Returns extended information on a single customer
      #
      #   @option options [String]
      #   @example Return extended information for customer 12345
      #     Desk.customer(12345)
      # @authenticated true
      # @see http://dev.desk.com/docs/api/customers/show
      def customer(id)
        response = get("customers/#{id}")
        response
      end

      # Create a new customer
      #
      #   @option options [String]
      #   @example Return extended information for 12345
      #     Desk.create_customer(:name => "Chris Warren", :twitter => "cdwarren")
      # @authenticated true
      # @see http://dev.desk.com/docs/api/customers/create
      def create_customer(*args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        response = post("customers",options)
        if response['success']
          response['results']['customer']
        else
          response
        end
      end

      # Update a customer
      #
      #   @option options [String]
      #   @example Return extended information for 12345
      #     Desk.update_customer(12345, :name => "Christopher Warren")
      # @authenticated true
      # @see http://dev.desk.com/docs/api/customers/update
      def update_customer(id, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        response = patch("customers/#{id}",options)
        if response['success']
          response['results']['customer']
        else
          response
        end
      end
    end
  end
end
