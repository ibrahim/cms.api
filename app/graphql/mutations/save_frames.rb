module Mutations
    SaveFrames = GraphQL::Relay::Mutation.define do
        name "SaveFrames"

        input_field :page_id, types.String
        input_field :frames, types[types.Int]
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
          
          frames = inputs[:frames]
          frames.each_with_index do |frame_id, idx|
            Frame.connection.execute("Update frames set lft=%d, rgt=%d where page_id=%d and id=%s" % [ (idx * 2) + 1, (idx * 2) + 2, page.id, frame_id])
          end

          return { 
            page: page,
          }
        end
    end
end
