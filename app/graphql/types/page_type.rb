Types::PageType = GraphQL::ObjectType.define do
    name "Page"
    description "A main content type"
    interfaces [GraphQL::Relay::Node.interface]
    global_id_field :id
    field :title, types.String, "The title of this page"
    field :db_id, types.Int, "The db id of this page", property: :id
    field :parent_id, types.Int, "The parent_id of this page", property: :parent_id
    field :blurb, types.String, "The slug of this page"
    field :url, types.String, "The url of this page"
    field :body, types.String, "The body of this page"
    field :short, types.String, "The short title of this page"
    field :room_price, types.String, "The room price of this resort"
    field :room_size, types.String
    field :room_max_occupancy, types.String
    field :room_occupancy_adults_children, types.String
    field :room_view, types.String
    field :room_vtour, types.String
    field :room_video, types.String
    field :room_booking_url, types.String
    field :photo, Types::PhotoType, "The primary photo of this page"
    field :slug, types.String do
        resolve ->(page, args, ctx) {
            page.to_slug
        }
    end
    connection :frames, Types::FrameType.connection_type do
            argument :order, types.String
            argument :limit, types.Int
            resolve ->(page, args, ctx) {
                frames = page.frames.order(args[:order] || "lft desc").includes(:photo)
                frames = frames.limit(args[:limit]) if args[:limit] > 0
                return frames
            }
    end
    connection :tags, Types::TagType.connection_type do
            argument :order, types.String
            argument :limit, types.Int
            resolve ->(page, args, ctx) {
                tags = page.tags
                return tags
            }
    end
    connection :children, Types::PageType.connection_type do
            argument :slug, types.String
            argument :title, types.String
            argument :order, types.String
            resolve ->(page, args, ctx) {
                children = page.children
                # children = children.where(slug: args[:slug]) unless args[:slug].blank?
                # children = children.where(title: args[:title]) unless args[:title].blank?
                children = children.reorder('').order(args[:order] || "pages.lft desc") if args[:order]
                children = children.includes([ { frames: :photo } , :photo, :translations]) if args[:slug].blank? && args[:title].blank?
                children.all
            }
    end
    connection :descendants, Types::PageType.connection_type do
            argument :slug, types.String
            resolve ->(page, args, ctx) {
                    descendants = page.descendants
                    descendants = descendants.where(slug: args[:slug]) unless args[:slug].blank?
                    descendants = descendants.where(title: args[:title]) unless args[:title].blank?
                    descendants = descendants.includes([ :frames, :photo] , :photo, :translations) if args[:slug].blank? && args[:title].blank?
                    descendants = descendants.order(args[:order] || "pages.lft desc")
                    descendants.all
            }
    end
    field :page, Types::PageType do
        argument :slug, types.String
        resolve ->(page, args, ctx) {
            page.children.where(slug: args[:slug]).first
        }
    end
    field :photo, Types::PhotoType do
        #argument :postId, types.Id, as: :id
        resolve ->(page, args, ctx) {
                page.photo
        }
    end
    connection :frames, Types::FrameType.connection_type do
        #argument :postId, types.Id, as: :id
        resolve ->(page, args, ctx) {
            page.frames.includes(:photo)
        }
    end
end
