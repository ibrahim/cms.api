Types::PhotoType = GraphQL::ObjectType.define do
    name "Photo"
    description "the photo"
    interfaces [GraphQL::Relay::Node.interface]
    global_id_field :id
    field :height, types.Int, "The height of this photo", property: :height
    field :width, types.Int, "The height of this photo", property: :width
    field :db_id, types.Int, "The db id of this photo", property: :id
    field :size, types.Int, "The file size of this photo", property: :size

    field :title, types.String
    field :photo_uri, types.String do
        argument :size, types.String
        resolve ->(photo, args, ctx) {
            photo.photo_uri(args[:size] || "medium")
        }
    end
    field :thumb_photo_uri, types.String do
        resolve ->(photo, args, ctx) {
            photo.photo_uri("small")
        }
    end
    field :medium_photo_uri, types.String do
        resolve ->(photo, args, ctx) {
            photo.photo_uri("medium")
        }
    end
    field :large_photo_uri, types.String do
        resolve ->(photo, args, ctx) {
            photo.photo_uri("gallery")
        }
    end
    field :photo_aspect_ratio, types.Int do
        resolve ->(photo, args, ctx) {
            ratio = ((photo.height * 100) / photo.width) if photo rescue nil
            ratio ? ratio : 0
        }
    end
end
