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
        @text << "<table style='font:300 15px Roboto, Arial;min-width:600px;'>"
        @text << "<tr><td colspan='2' style='padding:10px;text-align:center;font:400 22px Roboto, Arial;'>#{ form.get_msg("title","en") }</td></tr>"
        form.rows.each_with_index do |row, idx|
            if(row[:method]=~ /grades|message|comment/i)
            @text << "<tr style=\"background-color:#{ idx%2==0 ? '#F5f5f5' : 'FCFCFC' }\">"
            @text << "<td style=\"vertical-align:top;white-space:nowrap;padding:10px;\" colspan='2'><b>#{row[:label][locale]} </b></td></tr>"
            @text << "<tr style=\"background-color:#{ idx%2==0 ? '#F5f5f5' : 'FCFCFC' }\">"
            @text << "<td style=\"padding:10px;\" colspan='2'>" + render_item(get_key(row[:method])) + "</td>"
            @text << "</tr>"
            else
            @text << "<tr style=\"background-color:#{ idx%2==0 ? '#F5f5f5' : 'FCFCFC' }\">"
            @text << "<td style=\"vertical-align:top;white-space:nowrap;padding:10px;\"><b>#{row[:label][locale]} </b></td> "
            @text << "<td style=\"padding:10px;\">" + render_item(get_key(row[:method])) + "</td>"
            @text << "</tr>"
            end
        end
        @text << "</table>"
    end


    def render_item(item)

        ratings_colors = {}
        ratings_colors["Excellent"] = "#208101"
        ratings_colors["Very Good"] =  "#72b901" 
        ratings_colors["Good"] = "#c8e300" 
        ratings_colors["Fair"] = "#fbd400" 
        ratings_colors["Poor"] = "#f90f01" 

        case item.class.name
            when "Array"
                return item.join(", ")
            when "ActiveSupport::HashWithIndifferentAccess"
                return "<table style='min-width:600px;border-collapse:collapse;'>%s</table>" % [ item.map{|f,l| "<tr style='border-bottom:1px solid #eee;'><td style='padding:5px;'>#{f}</td><td style='padding:5px;color:#{ratings_colors[l]};text-align:center;'>#{l}</td></tr>" }.join ]
            else
                return item.to_s
        end
    end
end

