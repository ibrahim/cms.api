module Mutations
  MutationType = GraphQL::ObjectType.define do
    name "Mutation"
    field :saveForm,      field: SaveForm.field
    field :savePage,      field: SavePage.field
    field :saveStructure, field: SaveStructure.field
    field :createPart,    field: CreatePart.field
    field :deletePart,    field: DeletePart.field
    field :pasteClips,    field: PasteClips.field
    field :attachPhoto,   field: AttachPhoto.field
    field :attachFile,   field: AttachFile.field
  end
end
