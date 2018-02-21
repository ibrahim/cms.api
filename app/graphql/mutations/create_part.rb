module Mutations
    CreatePart = GraphQL::Relay::Mutation.define do
        name "CreatePart"

        input_field :structure_id, types.String
        input_field :page_id, types.String
        input_field :domain, types.String

        return_field :page, Types::PageType
        return_field :errors, types.String

        resolve ->(object, inputs, ctx) do
          # return { errors: "Authentication Required"} if current_user.blank?
          domain = Domain.where(name: inputs[:domain]).first
          current_site = ctx[:current_site]
          site = domain.site if domain
          return { errors: "UNIDENTIFIED SITE"} if site.blank?
            
          page = site.pages.find(inputs[:page_id])
          return { errors: "PAGE NOT FOUND"} if page.blank?
          
          structure = site.structures.find(inputs[:structure_id])
          return { errors: "STRUCTURE NOT FOUND"} if structure.blank?
            
          part = page.parts.where(structure_id: inputs[:structure_id]).first
          return { errors: "PART ALREADY EXISTS"} if part.present?
          
          part = Part.new(page: page, structure: structure, locale: I18n.locale.to_s)

           if part.save
             return { 
               page: page,
             }
           else
             return { errors: "Unable to create page part #{part.errors.to_yaml}"} 
           end
        end
    end
end
