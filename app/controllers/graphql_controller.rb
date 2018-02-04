class GraphqlController < ApplicationController
    # protect_from_forgery prepend: true
    # skip_before_filter :verify_authenticity_token
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
      current_site: current_site,
      remote_ip: request.remote_ip
    }
    result = ApiSchema.execute(query, variables: variables, context: context)
    render json: result
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end
end
