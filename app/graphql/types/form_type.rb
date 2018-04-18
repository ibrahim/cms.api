module Types
  FormType = GraphQL::ObjectType.define do
    name "Form"
    description "Form"
    global_id_field :id
    global_id_field :key
    field :db_id, !types.Int, property: :id
    field :title, !types.String
    field :slug, !types.String
    field :emails, types.String
    field :fields, types.String
    field :messages, types.String
    # field :fields, types.String
    # field :messages, types.String
    field :feedbacks, types[Types::FeedbackType] do
      argument :order, types.String
      argument :page_num, types.Int
      resolve ->(form, args, ctx) {
        feedbacks = form.feedbacks
        feedbacks = feedbacks.order("created_at desc")
        feedbacks = feedbacks.paginate(per_page: 50, page: args[:page_num])
        return feedbacks
      }
    end
    field :feedback, Types::FeedbackType, "one feedback from forms feedbacks" do
      argument :id, types.Int
      resolve ->(form, args, ctx) {
        feedback = form.feedbacks.where(id: args[:id]).first
        feedback
      }
    end
  end
end
