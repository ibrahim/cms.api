class Download < ApplicationRecord
  belongs_to :downloadable, :polymorphic => true, optional: true
  
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
  def title_or_name
    self.title.blank? ? self.name : self.title
  end
  def escaped_name
    URI.escape(name)
  end
end
