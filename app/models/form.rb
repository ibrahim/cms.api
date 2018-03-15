class Form < ApplicationRecord
  validates_presence_of :fields, :title
  # serialize :fields

  has_many :feedbacks

  def rows
    return @rows unless @rows.blank?
    @rows ||= []
    fields.each_line do |row|
      unless row.strip.blank?
        _method, _type, _label, _value, _note = row.strip.split("|")

        if _type=~/select|radio|checkbox|radio/ && _value && _value.index("#")
          _value = _value.split("#")
          _value_locale = {}
          _value.each do |lang|
            key, value = lang.split(":")
            _value_locale[key] = value.split(",")
          end
          _value = _value_locale

        end

        if _label && _label.index("#")
          _label = _label.split("#")
          _label_locales = {}
          _label.each do |lang|
            key, value = lang.split(":")
            _label_locales[key] = value
          end
          _label = _label_locales
        end

        if _note && _note.index("#")
          _note = _note.split("#")
          _note_locales = {}
          _note.each do |lang|
            key, value = lang.split(":")
            _note_locales[key] = value
          end
          _note = _note_locales
        end

        _row = { :method => _method, :type => _type, :label => _label, :value => _value , :note => _note }
        @rows << _row
      end
    end
    return @rows
  end

  def msgs
    return @msgs unless @msgs.blank?
    @msgs ||= {}
    messages.each_line do |line|
      unless line.blank?
        msg, locales = line.split("|")
        @msgs[msg] ||= {}
        locales_strs = locales.split("#")
        locales_strs.each do |locales_str|
          locale_code, str = locales_str.split(":")
          @msgs[msg][locale_code] = str
        end
      end
    end
    return @msgs
  end

  def get_msg(the_msg, locale)
    msgs[the_msg][locale.to_s]
  end

  def self.contactus!(site)
    f = new
    f.title = "Contact us"
    f.slug = "contactus"
    f.fields = <<-EOS
name|text_field|en:Name#| |
email|text_field|en:Email#| |
country|country|en:Country#| |
phone|phone|en:Phone Number#| |
message|text_area|en:Message / Comment#| |
EOS
    f.messages = <<-EOS
title|en:Contact us#
intro|en:<em>We look forward to receive any inquiries.</em>#
success|en:Thank you for contacting us. We will get back to you shortly.<br><br>Best Regards.#
EOS
    f.site_id = site.id
    f.save!
    return f
  end
end
