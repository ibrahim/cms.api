Types::PageType = GraphQL::ObjectType.define do
    name "Page"
    description "A main content type"
    interfaces [GraphQL::Relay::Node.interface]
    global_id_field :id
    # field :title, types.String, "The title of this page"
    field :db_id, types.Int, "The db id of this page", property: :id
    field :parent_id, types.Int, "The parent_id of this page", property: :parent_id
    # field :blurb, types.String, "The slug of this page"
    field :url, types.String, "The url of this page"
    # field :body, types.String, "The body of this page"
    field :short, types.String, "The short title of this page"

    # field :photo, Types::PhotoType, "The primary photo of this page"
    field :photo, Types::PhotoType do
        resolve ->(page, args, ctx) {
            RecordLoader.for(Photo).load(page.photo_id)
        }
    end
    field :slug, types.String do
        preload :translations
        resolve ->(page, args, ctx) {
            page.slug
            # AssociationLoader.for(PageTranslation, :page_id, { locale: "en"}).load([page.id]).then do |translations|
            #     translation = translations.first
            #     return "" if translation.blank?
            #     slug = page.slug
            #     title = translation.title
            #     !slug.blank? ? slug : title.gsub(/\s/, "_").gsub("&","and")
            # end
        }
    end
    field :title, types.String do
        preload :translations
        resolve ->(page, args, ctx) {
            # AssociationLoader.for(PageTranslation, :page_id, { locale: "en"}).load([page.id]).then do |translations|
            #     translations.first.try(:title)
            # end
            page.title
        }
    end
    field :blurb, types.String do
        preload :translations
        resolve ->(page, args, ctx) {
            # AssociationLoader.for(PageTranslation, :page_id, { locale: "en"}).load([page.id]).then do |translations|
            #     translations.first.try(:blurb)
            # end
            # page.blurb
            JSON.parse([page.blurb].to_json).first #, :quirks_mode => true)
            # JSON.parse(page.blurb.to_json , :quirks_mode => true)
        }
    end
    field :body, types.String do
        preload :translations
        resolve ->(page, args, ctx) {
            # AssociationLoader.for(PageTranslation, :page_id, { locale: "en"}).load([page.id]).then do |translations|
            #     translations.first.try(:body)
            # end
            # page.body
            JSON.parse([page.body].to_json).first #, :quirks_mode => true)
            # JSON.parse(page.body.to_json , :quirks_mode => true)
        }
    end
    field :url_title, types.String do
        preload :translations
        resolve ->(page, args, ctx) {
            # AssociationLoader.for(PageTranslation, :page_id, { locale: "en"}).load([page.id]).then do |translations|
            #     translation = translations.first
            #     return "" if translation.blank?
            #     title = translation.title
            #     title.gsub(/\s/, "_").gsub("&","and")
            # end
            page.url_title
        }
    end
    field :frames, types[Types::FrameType] do
            argument :order, types.String
            argument :limit, types.Int
            preload :frames
            resolve ->(page, args, ctx) {
                # frames = page.frames.order(args[:order] || "lft desc").includes(:photo)
                # frames = frames.limit(args[:limit]) if args[:limit] > 0
                # return frames
                page.frames
            }
    end
    field :downloads, types[Types::DownloadType] do
            argument :order, types.String
            argument :limit, types.Int
            preload :downloads
            resolve ->(page, args, ctx) {
                # frames = page.frames.order(args[:order] || "lft desc").includes(:photo)
                # frames = frames.limit(args[:limit]) if args[:limit] > 0
                # return frames
                page.downloads
            }
    end
    field :tags, types[Types::TagType] do
            argument :order, types.String
            argument :limit, types.Int
            preload :tags
            resolve ->(page, args, ctx) {
                # tags = page.tags
                # return tags
                page.tags
            }
    end
    field :children, types[Types::PageType] do
            argument :slug, types.String
            argument :title, types.String
            argument :order, types.String
            # preload [{ children: [ { frames: :photo } , :photo, :translations] }]
            preload :children
            resolve ->(page, args, ctx) {
                # children = page.children
                # # children = children.where(title: args[:title]) unless args[:title].blank?
                #children = children.reorder('').order(args[:order] || "pages.lft desc") if args[:order]
                # children = children.includes([ { frames: :photo } , :photo, :translations]) if args[:slug].blank? && args[:title].blank?
                page.children
            }
    end
    field :descendants, types[Types::PageType] do
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
            # AssociationLoader.for(Page, :parent_id, { slug: args[:slug]}).load([page.id]).then do |children|
            #     children.first
            # end
            page.children.where(slug: args[:slug]).first
        }
    end
end
