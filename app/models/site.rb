class Site < ActiveRecord::Base
	has_many :pages
  has_many :domains

  has_one :domain, ->{ where(primary: 1) }

  has_many :structures
  validates :name, uniqueness: true
  

  def primary_domain
    domains.where(primary: 1).first.try(:name)
  end

  def self.create_site!(name, domain)
    puts "Site already exists" and return if Site.exists?(name: name)
    ApplicationRecord.transaction do
      s = Site.create!(name: name, email: "#{name}@#{domain}", title: name, description: name)
      s.domains.create!(name: domain)
      frontpage = s.pages.create!(title: "Frontpage", slug: "frontpage")
      banner = s.pages.create!(title: "Frontpage Slider", slug: "main_slider")
      banner.move_to_child_of frontpage
      content   = s.pages.create!(title: "Content", slug: "content")
    end
  end
end
