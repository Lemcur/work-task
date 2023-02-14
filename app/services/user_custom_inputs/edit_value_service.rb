### This is side effect free - you need to commit to DB separately
### can raise UnknownTypeError or ActiveRecord::RecordNotFound
class UserCustomInputs::EditValueService
  class UnknownTypeError < StandardError; end

  def initialize(user:, type:, name:, value:)
    @user = user
    @type = type
    @name = name
    @value = value
  end

  def call
    if type == "string"
      custom_string
    elsif type == "number"
      custom_number
    elsif type == "single"
      custom_single_choice
    elsif type == "multiple"
      custom_multiple_choice
    else
      raise UnknownTypeError.new("unknown type: #{type}")
    end
  end

  private 

  attr_reader :user, :type, :name, :value

  def custom_number
    UserCustomValueInputs::Number.find_by!(user: user, name: name).tap { |input| input.value = value }
  end

  def custom_string
    UserCustomValueInputs::String.find_by!(user: user, name: name).tap { |input| input.value = value }
  end

  def custom_single_choice
    UserCustomChoiceInputs::Single.find_by!(user: user, name: name).tap { |input| input.selected = [value] } 
  end

  def custom_multiple_choice
    UserCustomChoiceInputs::Multiple.find_by!(user: user, name: name).tap { |input| input.selected = value } 
  end
end
