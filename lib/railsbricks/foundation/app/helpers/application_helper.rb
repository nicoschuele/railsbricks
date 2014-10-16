module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | BRICK_APP_NAME"      
    end
  end
end
