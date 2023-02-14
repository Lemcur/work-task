class Api::V1::UsersController < Api::V1::Base
  # rescue_from UserCustomInputs::EditValueService::UnknownTypeError, with: :render_unknown_type

  def update
    user = User.find(params[:id])

    error_inputs = []
    valid_inputs = []

    update_params.each do |param|
      custom_input = UserCustomInputs::EditValueService.new(
        user: user,
        type: param[:type],
        name: param[:name],
        value: param[:value],
      ).call

      if custom_input.valid?
        valid_inputs << custom_input
      else
        error_inputs << custom_input
      end
    end

    if error_inputs.length == 0
      User.transaction do 
        valid_inputs.each do |input|
          input.save!
        end
      end

      render jsonapi: user, include: [
        :user_custom_choice_inputs_multiple,
        :user_custom_choice_inputs_single,
        :user_custom_value_inputs_number,
        :user_custom_value_inputs_string,
      ]
    else
      render_failure(error_inputs)
    end
  end

  private
  
  def error_map
    super.merge({
      "UserCustomInputs::EditValueService::UnknownTypeError" => {
        code: :user_inputs_unknown_type,
        status: 400,
      }
    })
  end

  def render_failure(inputs)
    render json: { code: :invalid_payload, message: inputs.map { |i| i.errors.messages }.join("; ") }, status: 422
  end

  def update_params
    params.permit(_json: [:type, :name, :value, value: []])[:_json]
  end
end
