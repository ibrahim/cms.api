module Types
    FeedbackType = GraphQL::ObjectType.define do
        name "Feedback"
        description "Form Feedback"
        global_id_field :id
        global_id_field :key
        field :db_id, !types.Int, property: :id
        field :name, types.String
        field :email, types.String
        field :phone, types.String
        field :body, types.String, "body as json" do
          argument :id, types.Int
          resolve ->(feedback, args, ctx) {
            feedback.body.to_json
          }
        end
        field :created_at, types.Int, "body as json" do
          resolve ->(feedback, args, ctx) {
            feedback.created_at.to_i
          }
        end
    end
end
