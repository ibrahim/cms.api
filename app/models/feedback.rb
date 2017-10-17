class Feedback < ApplicationRecord
    belongs_to :form
  
    store :body, coder: JSON
    # validates_presence_of :name, :body, :form_id
    # named_scope :unread, :conditions => ['feedbacks.read is null']
    # named_scope :read, :conditions => {:read => 1}

    def get_key(k)
        if k.to_s =~ /^name|phone|email$/
            send(:"#{k}")
        else
            (body || {})[k]
        end
    end

    def to_text(locale="en")
        @text = ""
        @text << "<ul>"
        form.rows.each do |row|
            @text << "<li>"
            @text << "<b>#{row[:label][locale]} :</b>&nbsp;&nbsp; "
            @text << [get_key(row[:method])].flatten.join(", ")
            @text << "</li>"
        end
        @text << "</ul>"
    end
end
