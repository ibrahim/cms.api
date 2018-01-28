class Page < ActiveRecord::Base
	translates :title, :body, :blurb
  	acts_as_nested_set  :scope => [:site_id]
  	has_many  :frames, :dependent => :destroy do
		def photo_frame
			find(:first, :conditions => {:photo_id => proxy_owner.photo_id, :page_id => proxy_owner.id})
		end
	end
	has_many  :photos, :through => :frames
	has_many  :downloads, as: :downloadable
	belongs_to :photo, optional: true
	has_many  :taggings, as: :taggable, dependent: :destroy
  has_many :tags , through: :taggings


        def to_slug
            !slug.blank? ? slug : title.gsub(/\s/, "_").gsub("&","and")
        end
        def url_title
            title.gsub(/\s/, "_").gsub("&","and")
        end
end
