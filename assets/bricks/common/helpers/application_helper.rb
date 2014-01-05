module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | APPTEMPLATE"      
    end
  end
end