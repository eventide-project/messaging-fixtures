require_relative '../../../automated_init'

context "Handler" do
  context "Setup" do
    context "Stored Entity" do
      context "Specified" do
        context "Entity Version is Specified" do
          input_message = Controls::Message.example

          entity = Controls::Entity::Identified.example

          handler = Controls::Handler.example

          fixture = Handler.build(
            handler,
            input_message,
            entity,
            entity_version: 11
          )

          store = handler.store

          stored_entity, version = store.get(entity.id, include: :version)

          refute(stored_entity.nil?)

          test "Fixture entity is stored in handler's store" do
            assert(stored_entity == entity)
          end

          test "Entity version is the cache record's default version" do
            assert(version == 11)
          end
        end
      end
    end
  end
end
