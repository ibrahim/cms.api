Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :site, Types::SiteType do
    description "Site object"
    argument :name, !types.String
    resolve ->(obj, args, ctx) {
        site = Site.where(name: args[:name]).first
        site
    }
  end
end
