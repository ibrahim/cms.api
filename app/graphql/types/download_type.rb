Types::DownloadType = GraphQL::ObjectType.define do
    name "Download"
    description "the download"
    interfaces [GraphQL::Relay::Node.interface]
    global_id_field :id

    field :title, types.String
    field :uri, types.String do
        resolve ->(download, args, ctx) {
            download.uri
        }
    end
end
