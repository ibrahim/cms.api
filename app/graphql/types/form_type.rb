module Types
    FormType = GraphQL::ObjectType.define do
        name "Form"
        description "Form"
        global_id_field :id
        global_id_field :key
        field :db_id, !types.Int, property: :id
        field :title, !types.String
        field :slug, !types.String
        # field :fields, types.String
        # field :messages, types.String
    end
end
