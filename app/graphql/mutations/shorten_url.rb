module Mutations
    ShortenUrl = GraphQL::Relay::Mutation.define do
        name "ShortenUrl"

        input_field :page_id, types.String
        input_field :file_id, types.String
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
            
          page = site.pages.where(id: inputs[:page_id]).first
          return { errors: "PAGE NOT FOUND"} if page.blank?
            
          download = page.downloads.find(inputs[:file_id])
          return { errors: "PAGE DOWNLOAD FILE NOT FOUND"} if download.blank?

          short_url = Google::UrlShortener.shorten!(download.full_url)
          if download.update_attribute(:short_url, short_url)
             return { 
               page: page,
               file: download,
             }
           else
             return { errors: "Unable to save structure #{download.errors.to_yaml}"} 
           end
        end
    end
end
