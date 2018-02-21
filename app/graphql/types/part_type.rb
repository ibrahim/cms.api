module Types
    PartType = GraphQL::ObjectType.define do
        name "Part"
        description "Part"
        global_id_field :id
        global_id_field :key
        field :db_id, !types.Int, property: :id
        field :structure_id, !types.Int, property: :structure_id
        field :content, types.String
        field :structure, Types::StructureType do
            resolve ->(part, args, ctx) {
                RecordLoader.for(Structure).load(part.structure_id)
            }
        end
    end
end
