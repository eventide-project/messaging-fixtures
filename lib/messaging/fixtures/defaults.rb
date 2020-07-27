module Messaging
  module Fixtures
    class Handler
      module Defaults
        def self.time
          Time.utc(2000, 1, 1, 0, 0, 0, 11)
        end

        def self.uuid
          Identifier::UUID.zero
        end
      end
    end
  end
end
