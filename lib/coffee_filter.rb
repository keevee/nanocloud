require 'coffee-script'

class CoffeeFilter < Nanoc3::Filter
  identifier :coffee

  def run(content, params = {})
    CoffeeScript.compile(content)
  end
end
