Types::TagType = GraphQL::ObjectType.define do
    name "Tag"
    description "the tag"
    interfaces [GraphQL::Relay::Node.interface]

    global_id_field :id
    field :name, !types.String, "The tag name"
end
