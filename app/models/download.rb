class Download < ApplicationRecord
  belongs_to :downloadable, :polymorphic => true, optional: true
  belongs_to :site
  ICONS = %w(pdf doc docx xls zip avi htm js css ppt xml xls sql php jpg tif mp3 mov txt swf ra psd gif png flv pps rm pptx)
  
  def self.extension_code_of(i)
    ICONS.rindex(i)
  end

  #{{{ title
  def title
    self['title'].blank? ? self.name : self['title']
  end
  #}}}
  #{{{ icon
  def icon_extension
    ext = ((name||"").split(".").last || "").downcase
    return ext if ICONS.include?(ext)
    return "generic"
  end
  #}}}
  #{{{ icon_path
  def icon
    return "/images/doctypes/icon_#{icon_extension}.gif"
  end
  #}}}
  #{{{ savegeometry
  def savegeometry
    self.size = File.lstat(path).size
    self.save!
  end
  #}}}
  #{{{ storingfolder
  def storingfolder
    raise "Cannot guess folder path of a file whose record is not saved yet." if new_record?
    return "#{sprintf('%04d', (self.id/1000).ceil) }"
  end
  #}}}
  #{{{ uri
  def uri
    get_filename(nil)
  end
  #}}}
  #{{{ path
  def path()
    get_filename(true)
  end
  #}}}
  #{{{ get_filename
  def get_filename(abs)
    return "" if name.blank?
    #file_folder(abs) + "/#{id.to_s}.#{extension}" 
    ext = name=~/MP3/ ? "" : ".#{icon_extension}" #A hack
    #file_folder(abs) + "%s%s" % [ "/#{id_hash}", icon_extension=='generic' ? "" : ext ]
    file_folder(abs) + "/%s" % [ abs ? name : escaped_name ]
  end
  #}}}
  #{{{ file_folder
  def file_folder(abs=true)
    raise "Cannot guess folder path of a file whose record is not saved yet." if new_record?
    folder = (abs.nil?)? "" : Rails.root.join("public").to_s  
    file_folder = "#{folder}/files/#{storingfolder}/#{id}"
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
			FileUtils.makedirs(file_folder)
      handle = File.open(file_folder + "/#{name}","wb")
			handle.binmode
			handle.write bin_data
			handle.close
      return 
		end
	end
	#}}}
	#{{{ file=
	def file=(base64_data)
		return if base64_data.blank?
		save_uploaded_file(base64_data)
	end
	#}}}
  def title_or_name
    self.title.blank? ? self.name : self.title
  end
  def escaped_name
    URI.escape(name)
  end

  def full_url
     "#{site.try(:domain).try(:name)}#{uri}"
  end
end
