class ErrorSerializer
  def initialize(errors)
    @errors = [errors]
  end

  def serialize
    { message: 'your request could not be completed',
      error: @errors }
  end
end
