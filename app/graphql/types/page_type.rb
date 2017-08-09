Types::PageType = GraphQL::ObjectType.define do
    name "Page"
    description "A main content type"
    interfaces [GraphQL::Relay::Node.interface]
    global_id_field :id
    field :title, types.String, "The title of this page"
    field :slug, types.String, "The slug of this page"
    field :blurb, types.String, "The slug of this page"
    field :photo, Types::PhotoType, "The primary photo of this page"
    connection :frames, Types::FrameType.connection_type do
            argument :order, types.String
            resolve ->(page, args, ctx) {
                    page.frames.order(args[:order] || "lft desc").includes(:photo)
            }
    end
    connection :children, Types::PageType.connection_type do
            argument :slug, types.String
            argument :title, types.String
            resolve ->(page, args, ctx) {
                    children = page.children
                    # children = children.where(slug: args[:slug]) unless args[:slug].blank?
                    # children = children.where(title: args[:title]) unless args[:title].blank?
                    children = children.order(args[:order] || "pages.lft desc")
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
