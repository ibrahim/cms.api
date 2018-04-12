module Mutations
    SavePage = GraphQL::Relay::Mutation.define do
        # Used to name derived types, eg `"AddIdentityInput"`:
        name "SavePage"

        input_field :page_id, types.String
        input_field :parent_id, types.String
        input_field :title, types.String
        input_field :slug, types.String
        input_field :blurb, types.String
        input_field :published, types.Int
        input_field :body, types.String
        input_field :part, types.String

        return_field :page, Types::PageType
        return_field :errors, types.String

        resolve ->(object, inputs, ctx) do
            # return { errors: "Authentication Required"} if current_user.blank?
            
            current_site = ctx[:current_site]
            remote_ip = ctx[:remote_ip]
            
            return { errors: "UNIDENTIFIED SITE"} if current_site.blank?
            
            unless inputs[:page_id].blank?
              # Find page by ID
              page = current_site.pages.find_by_id(inputs[:page_id]) 
              return { errors: "PAGE NOT FOUND"} if page.blank?
            else
              # No page_id input then create new page for current_site
              page = Page.new(site: current_site)
            end


            # part = JSON.parse(inputs[:part]) if inputs[:part].present?
            page.body = inputs[:body] if inputs[:body].present?
            page.title = inputs[:title] if inputs[:title].present?
            page.slug = inputs[:slug] if inputs[:slug].present?
            page.blurb = inputs[:blurb] if inputs[:blurb].present?
            page.published = inputs[:published].to_i == 1 ? 1 : 0
            page.part = inputs[:part]if inputs[:part].present?
            parent = current_site.pages.where(id: inputs[:parent_id]).first
            if page.save
              page.move_to_child_of(parent) if parent.present?
              return { 
                page: page,
              }
            else
              return { errors: "Unable to save page #{page.errors.to_yaml}"} 
            end
        end
    end
end
