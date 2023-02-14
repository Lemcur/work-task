class UserCustomValueInputs::SerializableString < JSONAPI::Serializable::Resource
  type { "string" }
  
  attributes :id, :name, :value
end
