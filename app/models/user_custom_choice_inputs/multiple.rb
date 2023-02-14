class UserCustomChoiceInputs::Multiple < UserCustomChoiceInputs::Base
  validate :selected_in_choices

  def selected_in_choices
    return if selected.length > 0 && selected.all? { |s| s.in?(choices) }

    errors.add(:selected, 'no selected from choices')
  end
end
