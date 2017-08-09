Types::FrameType = GraphQL::ObjectType.define do
    name "Frame"
    description "the frame attached to the content that hold the photo"
    interfaces [GraphQL::Relay::Node.interface]

    global_id_field :id
    field :photo, !Types::PhotoType, "The photo inside the frame"
end
