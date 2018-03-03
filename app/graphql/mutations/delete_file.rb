module Mutations
    DeleteFile = GraphQL::Relay::Mutation.define do
        name "DeleteFile"

        input_field :page_id, types.String
        input_field :file_id, types.String
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
          
          download = page.downloads.find(inputs[:file_id])
          return { errors: "PAGE DOWNLOAD FILE NOT FOUND"} if download.blank?
          

           if download.destroy!
             return { 
               page: page,
             }
           else
             return { errors: "Unable to delete page file #{download.errors.to_yaml}"} 
           end
        end
    end
end
