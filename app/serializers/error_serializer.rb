# frozen_string_literal: true

ERROR_MAPPING = {
  404 => { status: 404, title: 'Not Found' },
  400 => { status: 400, title: 'Bad Request' },
  401 => { status: 401, title: 'Unauthorized' },
  422 => { status: 422, title: 'Unprocessable Entity' },
  500 => { status: 500, title: 'Internal Server Error' }
}.freeze

# ErrorSerializer serializes error responses into JSON API format.
class ErrorSerializer
  def self.serialize(params)
    status = params[:status]
    message = params[:message]
    error_attributes = ERROR_MAPPING[status] || {}
    error = {
      status: error_attributes[:status] || status.to_s,
      title: error_attributes[:title],
      detail: message
    }

    { errors: [error] }.to_json
  end
end
