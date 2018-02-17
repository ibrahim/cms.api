module Types
    StructureType = GraphQL::ObjectType.define do
        name "Structure"
        description "use defined Schema used for page arbitrary forms (parts)"
        global_id_field :id
        global_id_field :key
        field :db_id, !types.Int, property: :id
        field :name, !types.String, property: :name
        field :schema, types.String
        field :uischema, types.String
    end
end
