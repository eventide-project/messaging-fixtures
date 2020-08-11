module Messaging
  module Fixtures
    class Handler
      module Defaults
        def self.clock_time
          Time.utc(2000, 1, 1, 0, 0, 0, 11)
        end

        def self.identifier_uuid
          Identifier::UUID.zero
        end
      end
    end
  end
end
