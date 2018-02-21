require "base64"

class Photo < ActiveRecord::Base

  	after_destroy :remove_files
    belongs_to :site

	SQUARE    = 80
	THUMBNAIL = 120
	SMALL   = 240
	MEDIUM  = 320
	LARGE   = 640
	GALLERY = 1280

	SIZES = [ ["square",    SQUARE], 
		["thumbnail", THUMBNAIL], 
		["small",     SMALL], 
		["medium",    MEDIUM], 
		["large",     LARGE], 
		["gallery",   GALLERY] ]

    belongs_to :page, optional: true
    belongs_to :photo, foreign_key: 'id', optional: true


	#{{{ proper_size
	def Photo.proper_size(s)
		s = s.to_i
		sizes = SIZES.map{|sname, swidth| swidth }
		size_names = SIZES.map{|sname, swidth| sname }
		sizes << s
		sizes.sort!
		sindex = sizes.index(s)
		sindex = 0 if sindex<0
		size_names[[sindex,SIZES.length-1].min]
	end
	#}}}
	#{{{ proper_width
	def Photo.proper_width(s)
		SIZES.detect{|sname,swidth| sname==Photo.proper_size(s) }[1]
	end
	#}}}
	#{{{ size_name
	def Photo.size_name(s)
		return "thumbnail" if s < 0 || s >= SIZES.length  
		SIZES[s][0]
	end
	#}}}
  def get_height_for(size)
    ((self.height * size) / self.width)
  end
	#{{{ extension
	def extension
		return "jpg" if mime =~ /(jpeg|jpg)/
			return "gif" if mime =~ /gif/
			return "png" if mime =~ /png/
		"jpg"
	end
	#}}}
	#{{{ savegeometry
	def savegeometry
		idn = `identify -ping #{photo_file}`
		#this_size = idn.gsub(photo_file,'').chomp.strip.split(' ')[1]
		atts = idn.gsub(photo_file,'').chomp.strip.split(' ')
    this_size = atts[1]
    this_filetype = atts[0]
    this_filesize = atts.last.to_i
		self.width, self.height = this_size.to_s.split("x")
		#self.size = File.lstat(photo_file).size
    self.size= this_filesize
    self.mime = MIME::Types.type_for(this_filetype).to_s
		self.save!
	end
	#}}}
	#{{{ storingfolder
	def storingfolder
		raise "Cannot guess folder path of a photo whose record is not saved yet." if new_record?
		return "#{sprintf('%04d', (self.id/1000).ceil) }"
	end
	#}}}
	#{{{ save_uploaded_file_binary
	def save_uploaded_file_binary(bin_data)
		unless bin_data.nil?
			save! if new_record?
			FileUtils.makedirs(photo_folder)
			handle = File.open(photo_file,"w")
			handle.binmode
			handle.write bin_data
			handle.close
			savegeometry
			update_thumbnails
      return 
		end
	end
	#}}}
	#{{{ save_uploaded_file
	def save_uploaded_file(base64_data)
		unless base64_data.nil?
			save! if new_record?
      rgx = /\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)/m
      data_uri_parts = base64_data.match(rgx) || []
      ext = MIME::Types[data_uri_parts[1]].first.preferred_extension
      bin_data = Base64.decode64(data_uri_parts[2]) 
			FileUtils.makedirs(photo_folder)
      handle = File.open(photo_folder + "/#{photo.id}.#{extension}","wb")
			handle.binmode
			handle.write bin_data
			handle.close
			savegeometry
			update_thumbnails
      return 
		end
	end
	#}}}
	#{{{ update_thumbnails
	def update_thumbnails
    return if new_record?
		srand Time.now.to_i
		degrees = (-9..9).map{ |n| [n] }
    quality = "85"
		`convert #{ photo_file } -resize "#{GALLERY}>" -quality #{quality}  #{ photo_file('gallery') }`
		`convert #{ photo_file(:gallery) } -resize "#{LARGE}>"  -quality #{quality} #{ photo_file('large') } `
		`convert #{ photo_file(:large) } -resize "#{MEDIUM}>" -quality #{quality}  #{ photo_file('medium')} `
		`convert #{ photo_file(:medium) } -resize "#{SMALL}>"  -quality #{quality}  #{ photo_file('small')} `
		`convert #{ photo_file(:small) } -resize "#{SQUARE}>" -quality #{quality} #{ photo_file('square')} &`
		`convert #{ photo_file(:small) } -thumbnail "#{THUMBNAIL}x#{THUMBNAIL}>"  -quality #{quality} #{ photo_file('thumbnail') } &`
		#`convert #{photo_file} -resize "50x50" -crop "50x50" -bordercolor white  -border 2  -bordercolor grey60 -border 1 -background none  -rotate 0 -background black  \\( +clone -shadow 20x1+1+1 \\) +swap  -background white -flatten -format jpg #{photo_file('thumbnail')} `

		#degree = degrees[rand(18)]
		#`convert #{photo_file} -resize "160>" -bordercolor white  -border 4  -bordercolor grey60 -border 1 -background none  -rotate #{degree}  -background black  \\( +clone -shadow 45x2+2+2 \\) +swap  -background white  -flatten #{photo_file('frame')} `
	end
	#}}}
	#{{{ photo_uri
	def photo_uri(size=nil)
		size = size.to_s
		size=nil if size.blank?
		#unless size.nil?
		#	if File.exists?("#{photo_folder}/#{id}.#{extension}") && !File.exists?("#{photo_folder}/#{size}_#{id}.#{extension}")
		#		update_thumbnails
		#	end
		#end
    #return "/images/default.png" unless existing_file?(size)
		get_filename(nil,size)
	end
	#}}}
	#{{{ photo_file
	def photo_file(size=nil)
		get_filename(true,size)
	end
	#}}}
	#{{{ get_filename
	def get_filename(abs,size=nil)
		size = "#{size}_" unless size.nil?
		photo_folder(abs) + "/#{size}#{id.to_s}.#{extension}" 
	end
	#}}}
	#{{{ photo_folder
	def photo_folder(abs=true)
		raise "Cannot guess folder path of a photo whose record is not saved yet." if new_record?
		folder = (abs.nil?)? "" : Rails.root.join("public")  
		photo_folder = "#{folder}/photos/#{storingfolder}/#{id}"
	end
	#}}}
	#{{{ send_binary
	def send_binary(size=nil,force=nil)
		#save_binary size, force
		handle = File.open(photo_file,"r")
		handle.binmode
		photo_bin = handle.read
	end
	#}}}
	#{{{ save_binary
	def save_binary(size=nil,force=nil)
		if (File.exists?(photo_file) == false) || force  
			FileUtils.makedirs(photo_folder)
			photo_bin = Base64.decode64(self.figure)
			handle = File.open(photo_file,"w")
			handle.binmode
			handle.write photo_bin
			handle.close
		else
		end
	end
	#}}}
	#{{{ file=
	def file=(base64_data)
		return if base64_data.blank?
		save_uploaded_file(base64_data)
	end
	#}}}

  def existing_file?(size=nil)
  	return true
		size = "#{size}_" unless size.nil?
    File.exists?("#{photo_folder}/#{size}#{id}.#{extension}")
  end

	def ensure_only_thumbnail
		if self['thumbnail'].to_i == 1 
			Photo.update_all("thumbnail=0", sprintf("photoable_type='%s' and photoable_id=%s and id <> %s and thumbnail=1", photoable_type, photoable_id, id))
		end
    return true
	end
  
  def remove_files
      FileUtils.remove_dir(photo_folder, true)
  end

  def underline
    return title unless title.blank?
    return "..."
  end


  def self.included_associations
      included = [:thetext, { :user => [:photo, :domain] }, :user_topic, {:original => [{ :user => :photo }, :thetext] } ]
  end

end
