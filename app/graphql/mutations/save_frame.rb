module Mutations
    SaveFrame = GraphQL::Relay::Mutation.define do
        name "SaveFrame"

        input_field :page_id, types.String
        input_field :frame_id, types.String
        input_field :tags, types[types.String]
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
          
          frame = page.frames.find(inputs[:frame_id])
          return { errors: "PAGE PHOTO ATTACHEMENT NOT FOUND"} if frame.blank?
          
          frame.tags = inputs[:tags]
           if frame.save
             return { 
               page: page,
             }
           else
             return { errors: "Unable to remove photo attachment #{frame.errors.to_yaml}"} 
           end
        end
    end
end
