class Api::V1::Base < ApplicationController
  rescue_from StandardError do |e|
    handle_error(e)
    # TODO: log error
  end
  # rescue_from ActiveRecord::RecordNotFound, with: :not_found
  
  protected 
  
  def error_map
    {
      "ActiveRecord::RecordNotFound" => {
        code: :not_found,
        status: 404,
      },
    }
  end

  def handle_error(e)
    if error_map.include?(e.class.name)
      render json: { 
        code: error_map[e.class.name][:code],
        message: e.message,
      }, status: error_map[e.class.name][:status]
    else
      render json: { 
        code: :generic_error,
        message: e.message,
      }, status: 400
    end
  end

  private

  def not_found(err)
    render json: { code: :not_found, message: err.message }, status: 404
  end

  def generic_error(err)
    render json: { code: generic_error, message: err.message }, status: 400
  end
end