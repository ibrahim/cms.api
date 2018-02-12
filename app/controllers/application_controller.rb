class ApplicationController < ActionController::API
    before_action :set_locale
    #protect_from_forgery with: :exception

    #before_action :get_domain
    #helper_method :current_site

    def current_site
      @site = Site.first
    end

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    def get_domain
      request_host = request.host
      @domain = Domain.find_by_name(request_host)
      # render(:text => "Domain (#{request_host}) is not registered",  :layout => false) and return false if @domain.nil?
      raise("Domain (#{request_host}) is not registered") if @domain.nil?
      @site = Site.find_by_id(@domain.site_id)
      #render( :text => 'Site does not exist', :layout => false) and return false if @site.nil?
      raise("Site (#{request_host}) does not exist") if @site.nil?
      # unless @domain.primary? 
      #   primary_domain = @site.primary_domain
      #   primary_domain.update_attribute(:primary, 1) if primary_domain.primary.zero?
      #   path = "#{primary_domain.full_url}#{request.path}"
      #   path += "?#{request.query_string}" unless request.query_string.blank?
      #   head :moved_permanently, :location =>  path and return false
      # end
    end
end
