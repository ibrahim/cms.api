class Page < ActiveRecord::Base
	translates :title, :body, :blurb
  	acts_as_nested_set  :scope => [:site_id]
  	has_many  :frames, :dependent => :destroy do
		def photo_frame
			find(:first, :conditions => {:photo_id => proxy_owner.photo_id, :page_id => proxy_owner.id})
		end
	end
	has_many  :photos, :through => :frames
	belongs_to :photo
	has_many  :taggings, as: :taggable, dependent: :destroy
        has_many :tags , through: :taggings


        def to_slug
            slug ? slug : title.gsub(/\s/, "_")
        end
end
