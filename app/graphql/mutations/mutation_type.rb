module Mutations
    MutationType = GraphQL::ObjectType.define do
        name "Mutation"
        field :saveForm, field: SaveForm.field
        field :savePage, field: SavePage.field
    end
end
