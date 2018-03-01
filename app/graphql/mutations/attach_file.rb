module Mutations
    AttachFile = GraphQL::Relay::Mutation.define do
        name "AttachFile"

        input_field :page_id, types.String
        input_field :file, types.String
        input_field :name, types.String
        input_field :domain, types.String

        return_field :file, Types::FileType
        return_field :page,  Types::PageType
        return_field :errors, types.String

        resolve ->(object, inputs, ctx) do
          # return { errors: "Authentication Required"} if current_user.blank?
          domain = Domain.where(name: inputs[:domain]).first
          current_site = ctx[:current_site]
          site = domain.site if domain
          return { errors: "UNIDENTIFIED SITE"} if site.blank?
          return { errors: "EMPTY FILE DATA"} if inputs[:file].blank?
            
          page = site.pages.where(id: inputs[:page_id]).first
          return { errors: "PAGE NOT FOUND"} if page.blank?
            
          download = Download.new
          download.site = site
          download.title = inputs[:name]
          download.name = inputs[:name]
          download.file = inputs[:file]
          download.downloadable = page
           if download.save
             return { 
               page: page,
               file: download,
             }
           else
             return { errors: "Unable to save structure #{structure.errors.to_yaml}"} 
           end
        end
    end
end
