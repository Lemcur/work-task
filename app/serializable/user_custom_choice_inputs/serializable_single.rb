class UserCustomChoiceInputs::SerializableSingle < JSONAPI::Serializable::Resource
  type { "single" }

  attributes :id, :name, :choices

  attribute :selected do 
    @object.selected.first
  end
end
