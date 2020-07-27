module Messaging
  module Fixtures
    module Controls
      module Store
        module Projection
          class Example
            include EntityProjection
          end
        end

        module Reader
          class Example
            include MessageStore::Read
          end
        end

        class Example
          include EntityStore

          category :example
          entity Entity::Example
          projection Store::Projection::Example
          reader Store::Reader::Example
        end
      end
    end
  end
end
