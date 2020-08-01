module Messaging
  module Fixtures
    module Controls
      module Entity
        class Example
          include Schema::DataStructure

          attribute :id, String
          attribute :alternate_condition, Boolean, default: false
          attribute :sequence, Integer

          alias :alternate_condition? :alternate_condition

          def processed?(message_sequence)
            return false if sequence.nil?

            message_sequence <= sequence
          end
        end

        def self.example(sequence: nil)
          sequence ||= self.sequence

          some_entity = Example.build

          some_entity.id = id
          some_entity.sequence = sequence

          some_entity
        end

        def self.id
          ID.example(increment: id_increment)
        end

        def self.id_increment
          11
        end

        def self.amount
          1
        end

        def self.sequence
          Event.sequence
        end

        module New
          def self.example
            Entity::Example.new
          end
        end

        module Identified
          def self.example
            example = New.example

            example.id = Entity.id

            example
          end
        end

        module Sequenced
          def self.example
            example = Identified.example

            example.sequence = Entity.sequence

            example
          end
        end
      end
    end
  end
end
