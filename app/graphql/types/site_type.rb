Types::SiteType = GraphQL::ObjectType.define do
  name "Site"
  description "A Site"
  interfaces [GraphQL::Relay::Node.interface]

  global_id_field :id
  field :title, !types.String, "The title of the site"
  field :name, !types.String, "The name of the site"
  field :pages, types[Types::PageType], "pages of this site" do
    argument :order, types.String
    argument :id, types.String
    argument :slug, types.String
    resolve ->(site, args, ctx) {
      pages = site.pages
      pages = pages.limit(50)
      parent = site.pages.where(slug: args[:slug]) unless args[:slug].blank?
      parent = site.pages.where(id: args[:id]) unless args[:id].blank?
      pages = parent.blank? ? pages.roots : pages.where(parent_id: parent.first.id)
      pages = pages.order(args[:order] || 'lft asc' )
      pages
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
  field :structures, types[Types::StructureType], "structures of this site" do
    resolve ->(site, args, ctx) {
      site.structures
    }
  end
  field :structure, Types::StructureType, "structure of this site" do
    argument :id, types.String
    resolve ->(site, args, ctx) {
      site.structures.where(args[:id]).first
    }
  end
end
