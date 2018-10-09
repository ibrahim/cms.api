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
      pages = pages.limit(200)
      parent = site.pages.where(slug: args[:slug]) unless args[:slug].blank?
      parent = site.pages.where(id: args[:id]) unless args[:id].blank?
      pages = parent.blank? ? pages.roots : pages.where(parent_id: parent.first.id)
      pages = pages.order(args[:order] || 'lft asc' )
      pages
    }
  end
  field :forms, types[Types::FormType], "forms of this site" do
    resolve ->(site, args, ctx) {
      forms = site.forms
      forms = forms.limit(200)
      forms
    }
  end
  field :page, Types::PageType do
    description "The page"
    argument :title, types.String
    argument :slug, types.String
    argument :published, types.Int
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
  field :part, Types::PartType do
          argument :id, types.Int
          argument :structure_id, types.Int
          resolve ->(site, args, ctx) {
            structure = Structure.where(id: args[:structure_id], site_id: site.id).first if args[:structure_id].present?
            parts = structure && args[:id].present? ? Part.where({structure_id: structure.id, id: args[:id]}).first : nil
          }
  end
  field :parts, types[Types::PartType] do
          argument :structure_id, types.Int
          resolve ->(site, args, ctx) {
            structure = Structure.where(id: args[:structure_id], site_id: site.id).first if args[:structure_id].present?
            parts = Part.where({structure_id: structure.id}) if structure
            parts.all
          }
  end
  field :form, Types::FormType, "one form of this site" do
    argument :slug, types.String
    resolve ->(site, args, ctx) {
      site.forms.where(slug: args[:slug]).first
    }
  end
  field :structure, Types::StructureType, "structure of this site" do
    argument :id, types.Int
    resolve ->(site, args, ctx) {
      site.structures.where(id: args[:id]).first
    }
  end
end
