class FeedbackMailer < ApplicationMailer
    default from: 'info@sunrise-resorts.com'
 
  def feedback_mail(feedback, site)
    @sent_on = Time.now
    @feedback = feedback

    mail(
        to: feedback.form.emails,
        from: feedback.email,
        subject:  "#{site.title} - #{feedback.form.get_msg("title","en")} [#{feedback.name}]",
        content_type: "text/html"
        )
  end
end
