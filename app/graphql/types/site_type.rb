Types::SiteType = GraphQL::ObjectType.define do
  name "Site"
  description "A Site"
  interfaces [GraphQL::Relay::Node.interface]

  global_id_field :id
  field :title, !types.String, "The title of the site"
  field :name, !types.String, "The name of the site"
  field :pages, types[Types::PageType], "pages of this site" do
    argument :order, types.String
    resolve ->(site, args, ctx) {
      site.pages.order(args[:order] || 'lft asc' ).limit(50)
    }
  end
  field :page, Types::PageType do
    description "The page"
    argument :title, types.String
    argument :slug, types.String
    argument :id, types.String
    resolve ->(site, args, ctx) {
      page = site.pages.where(slug: args[:slug] ) unless args[:slug].blank?
      page = site.pages.where(id: args[:id] ) unless args[:id].blank?
      page = site.pages.where(title: args[:title] ) unless args[:title].blank?
      #page.preload(:photos, :photo, :translations)
      page.first
    }

  end
end
