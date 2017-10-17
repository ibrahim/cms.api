SunriseApiSchema = GraphQL::Schema.define do
  query Types::QueryType
  mutation Mutations::MutationType

  resolve_type ->(obj, ctx) do
      case obj.class.name
    when "Page"
      Types::PageType
    when "Photo"
      Types::PhotoType
    when "Frame"
      Types::FrameType
    when "Site"
      Types::SiteType
    when "Feedback"
      Types::FeedbackType
    when "Form"
      Types::FormType
    else
      raise("Don't know how to get the GraphQL type of a #{obj.class.name} (#{obj.inspect})")
    end
  end

  object_from_id ->(id, ctx) do
    type_name, item_id = GraphQL::Schema::UniqueWithinType.decode(id)

    # This `find` gives the user unrestricted access to *all* the records in your app. In
    # a real world application you probably want to check if the user is allowed to access
    # the requested resource.
    type_name.constantize.find(item_id)
  end

  id_from_object -> (object, type_definition, ctx) do
    GraphQL::Schema::UniqueWithinType.encode(type_definition.name, object.id)
  end
end
