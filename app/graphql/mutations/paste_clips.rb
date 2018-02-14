module Mutations
    PasteClips = GraphQL::Relay::Mutation.define do
        # Used to name derived types, eg `"AddIdentityInput"`:
        name "PasteClips"

        input_field :page_id, types.String
        input_field :clips, types[types.Int]
        input_field :type, types.String

        return_field :status, types.String
        return_field :errors, types.String

        resolve ->(object, inputs, ctx) do
            # return { errors: "Authentication Required"} if current_user.blank?
            
            current_site = ctx[:current_site]
            remote_ip = ctx[:remote_ip]
            
            return { errors: "UNIDENTIFIED SITE"} if current_site.blank?
            return { errors: "EMPTY CLIPS"} if inputs["clips"].blank?
            
            if inputs[:page_id].present?
              # Find page by ID
              parent = current_site.pages.find_by_id(inputs[:page_id]) 
              return { errors: "PAGE NOT FOUND"} if parent.blank?
            else
              move_pages_to_root = true
              fail_pasting_photos = true
            end


            case inputs["type"]
              when "pages"
                pages = current_site.pages.where(id: inputs["clips"])
                move_pages_to_root ? pages.each(&:move_to_root) : pages.each{|page| page.move_to_child_of(parent)}
              when "photos"
                #TODO
            end
            return { 
              status: "success",
            }
        end
    end
end
