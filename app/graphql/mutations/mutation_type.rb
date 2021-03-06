module Mutations
  MutationType = GraphQL::ObjectType.define do
    name "Mutation"
    field :saveForm,      field: SaveForm.field
    field :savePage,      field: SavePage.field
    field :saveStructure, field: SaveStructure.field
    field :savePart,      field: SavePart.field
    field :createPart,    field: CreatePart.field
    field :deletePart,    field: DeletePart.field
    field :pasteClips,    field: PasteClips.field
    field :attachPhoto,   field: AttachPhoto.field
    field :attachFile,    field: AttachFile.field
    field :deleteFile,    field: DeleteFile.field
    field :shortenUrl,    field: ShortenUrl.field
    field :deleteFrame,   field: DeleteFrame.field
    field :saveFrame,     field: SaveFrame.field
    field :saveFrames,    field: SaveFrames.field
    field :primaryPhoto,  field: PrimaryPhoto.field
  end
end
