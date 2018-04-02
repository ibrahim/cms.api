Types::FrameType = GraphQL::ObjectType.define do
    name "Frame"
    description "the frame attached to the content that hold the photo"
    interfaces [GraphQL::Relay::Node.interface]

    global_id_field :id
    field :db_id, types.Int, "The db id of this frame", property: :id
    field :lft, types.Int, "The lft position of this frame", property: :lft
    field :page_id, types.Int, "Page id", property: :page_id
    field :photo_id, types.Int, "Photo id", property: :photo_id
    #field :photo, !Types::PhotoType, "The photo inside the frame"
    field :photo, Types::PhotoType do
        resolve ->(frame, args, ctx) {
            RecordLoader.for(Photo).load(frame.photo_id)
        }
    end
    field :tags, types[types.String] do
        resolve ->(frame, args, ctx) {
          frame.tags
        }
    end
end
