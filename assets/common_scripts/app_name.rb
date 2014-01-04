# define app name

def app_name(word)
  if word.scan(/\_|\-/).size > 0
    word.split(/\_|\-/).map(&:capitalize).join 
  else
    word.slice(0,1).capitalize + word.slice(1..-1)
  end

end

def replace_with_app_name(app_name, template)
  template.gsub(/APPTEMPLATE/, app_name)  
end