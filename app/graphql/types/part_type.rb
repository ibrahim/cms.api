module Types
    PartType = GraphQL::ObjectType.define do
        name "Part"
        description "Part"
        global_id_field :id
        global_id_field :key
        field :db_id, !types.Int, property: :id
        field :content, types.String
    end
end
