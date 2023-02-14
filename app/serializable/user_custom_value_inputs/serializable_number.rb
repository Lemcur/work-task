class UserCustomValueInputs::SerializableNumber < JSONAPI::Serializable::Resource
  type { "number" }

  attributes :id, :name, :value
end
