Types::FileType = GraphQL::ObjectType.define do
    name "File"
    description "the file"
    interfaces [GraphQL::Relay::Node.interface]
    global_id_field :id

    field :title, types.String
    field :db_id, types.Int, property: :id
    field :name, types.String
    field :size, types.Int
    field :uri, types.String do
        resolve ->(download, args, ctx) {
            download.uri
        }
    end
    field :short_url, types.String do
        resolve ->(download, args, ctx) {
          download.short_url
        }
    end
end
