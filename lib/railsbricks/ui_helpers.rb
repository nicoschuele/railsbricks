module UiHelpers
  
  def self.colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end
  
  RED = 31
  
  GREEN = 32
  
  BLUE = 34
  
end