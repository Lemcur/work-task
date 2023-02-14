class UserCustomChoiceInputs::Single < UserCustomChoiceInputs::Base
  validate :selected_one_of_choices

  def selected_one_of_choices
    return if selected.length == 1 && selected.first.in?(choices)

    errors.add(:selected, 'not in choices or not single')
  end
end
