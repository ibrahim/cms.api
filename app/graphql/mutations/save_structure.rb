module Mutations
    SaveStructure = GraphQL::Relay::Mutation.define do
        # Used to name derived types, eg `"AddIdentityInput"`:
        name "SaveStructure"

        input_field :structure_id, types.String
        input_field :domain, types.String
        input_field :name, types.String
        input_field :schema, types.String
        input_field :uischema, types.String

        return_field :structure, Types::StructureType
        return_field :errors, types.String

        resolve ->(object, inputs, ctx) do
          # return { errors: "Authentication Required"} if current_user.blank?
          domain = Domain.where(name: inputs[:domain]).first
          current_site = ctx[:current_site]
          site = domain.site if domain
          return { errors: "UNIDENTIFIED SITE"} if site.blank?
            
            
            if inputs[:structure_id].present?
              structure = site.structures.where(id: inputs[:structure_id]).first
              return { errors: "STRUCTURE NOT FOUND"} if structure.blank?
            else
              structure = Structure.new(site: site)
            end


           structure.schema = inputs[:schema] if inputs[:schema].present?
           structure.uischema = inputs[:uischema] if inputs[:uischema].present?
           structure.name = inputs[:name] if inputs[:name].present?
           if structure.save
             return { 
               structure: structure,
             }
           else
             return { errors: "Unable to save structure #{structure.errors.to_yaml}"} 
           end
        end
    end
end
