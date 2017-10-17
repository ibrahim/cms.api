def verify_recapcha(gRecaptchaResponse, remote_ip)
    require 'uri'
    require 'net/http'
    require 'json'
    require 'openssl'
    uri = URI("https://www.google.com/recaptcha/api/siteverify")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true  if uri.port == 443
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    #https.ssl_options = OpenSSL::SSL::SSL_OP_NO_SSLv2 | OpenSSL::SSL::OP_NO_SSLv3 | OpenSSL::SSL::SSL_OP_NO_COMPRESSION
    reqheaders = {}
    reqheaders["secret"]    = "6LcDBhsUAAAAAPpP2azdFSb9DhMxsiH9T7HEiheo" #"6LeI0hoUAAAAAABzHMMPfvsBlmqUX0iBM-Dx00oo"
    reqheaders["response"]  = gRecaptchaResponse #params["g-recaptcha-response"]
    reqheaders["remoteip"]  = remote_ip
    #verify_request["challenge"] = params[:recaptcha_challenge_field]
    #verify_request["content-type"]  = "application/x-www-form-urlencoded"
    req = Net::HTTP::Post.new(uri.path)
    req["content-length"]  = reqheaders.to_s.length
    req.set_form_data(reqheaders)
    res = https.request(req)
    return JSON.parse(res.body)["success"]

    #raise params.to_yaml
    #raise verify_request.to_yaml
    #res = https.request(verify_request)
end

module Mutations
    SaveForm = GraphQL::Relay::Mutation.define do
        # Used to name derived types, eg `"AddIdentityInput"`:
        name "SaveForm"

        input_field :form, !types.String
        input_field :name, !types.String
        input_field :email, types.String
        input_field :phone, types.String
        input_field :body, !types.String
        input_field :gRecaptchaResponse, !types.String

        return_field :form, Types::FormType
        return_field :feedback, Types::FeedbackType
        return_field :email, types.String
        return_field :errors, types.String

        resolve ->(object, inputs, ctx) do
            # return { errors: "Authentication Required"} if current_user.blank?
            
            current_site = ctx[:current_site]
            remote_ip = ctx[:remote_ip]
            form = Form.find_by_slug(inputs[:form]) 

            feedback = Feedback.new
            parsed_body = JSON.parse(inputs[:body])
            feedback.body = parsed_body
            feedback.name = inputs[:name]
            feedback.email = inputs[:email]
            feedback.phone = inputs[:phone]
            feedback.site_id = current_site.id
            feedback.form_id = form.id

            if verify_recapcha(inputs[:gRecaptchaResponse], remote_ip)
                if feedback.save
                    FeedbackMailer.feedback_mail(feedback, current_site).deliver_now
                    return { 
                        form: form,
                        feedback: feedback,
                    }
                else
                    render :action => 'new'
                end
            else
                return { errors: "Unable to verfiy Recaptcha"} 
            end
        end
    end
end
