module Types
    FeedbackType = GraphQL::ObjectType.define do
        name "Feedback"
        description "Form Feedback"
        global_id_field :id
        global_id_field :key
        field :db_id, !types.Int, property: :id
        field :name, !types.String
        field :email, !types.String
        field :phone, types.String
        field :body, types.String
    end
end
