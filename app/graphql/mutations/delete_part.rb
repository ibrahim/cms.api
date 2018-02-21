module Mutations
    DeletePart = GraphQL::Relay::Mutation.define do
        name "DeletePart"

        input_field :page_id, types.String
        input_field :part_id, types.String
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
          
          part = page.parts.find(inputs[:part_id])
          return { errors: "PART NOT FOUND"} if part.blank?
          

           if part.destroy!
             return { 
               page: page,
             }
           else
             return { errors: "Unable to delete page part #{part.errors.to_yaml}"} 
           end
        end
    end
end
