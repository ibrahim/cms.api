class Site < ActiveRecord::Base
	has_many :pages
        has_many :domains
end
