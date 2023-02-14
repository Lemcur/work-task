class UserCustomChoiceInputs::SerializableMultiple < JSONAPI::Serializable::Resource
  type { "multiple" }

  attributes :id, :name, :choices, :selected
end
