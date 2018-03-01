class Page < ActiveRecord::Base
	translates :title, :body, :blurb
  acts_as_nested_set  :scope => [:site_id]
  has_and_belongs_to_many :structures
  
  has_many  :frames, :dependent => :destroy do
		def photo_frame
			find(:first, :conditions => {:photo_id => proxy_owner.photo_id, :page_id => proxy_owner.id})
		end
	end

  scope :roots, -> { where(parent_id: nil) }
	
	belongs_to :photo, optional: true
	belongs_to :site
  has_many :parts
  has_many :photos, :through => :frames
	has_many :downloads, as: :downloadable
	has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags , through: :taggings

  def part=(h)
    # Find structure by name
    parse_part = JSON.parse(h)
    name = parse_part['name']
    content = parse_part['content']
    structure = Structure.where(name: name).first if name
    errors.add(:part, "Structure name not found") and return if structure.blank?
    errors.add(:part, "Cannot add part to unsaved page") and return if self.new_record?
    part = Part.where(page_id: self.id, locale: I18n.locale).first
    part = Part.new(page: self, structure: structure, locale: I18n.locale) if part.blank?
    part.content = content.to_json
    part.save!
  # rescue JSON::ParserError => e
  #   errors.add(:part, "Part content json parse error")
  # rescue ActiveRecord::RecordInvalid => invalid
  #   error.add(:part, "Part is not valid #{invalid.errors}")
  end


  def to_slug
    !slug.blank? ? slug : title.gsub(/\s/, "_").gsub("&","and")
  end

  def url_title
    title.gsub(/\s/, "_").gsub("&","and")
  end
end
