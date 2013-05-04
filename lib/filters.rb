require 'coffee-script'

class ListFilter < Nanoc3::Filter
  identifier :list
  type :text

  def run(content, params={})
    '<p>'+content.gsub(/^(.*?:) (.*)$/, '<span class="label">\1</span> \2<br>')
  end
end

class HeadFilter < Nanoc3::Filter
  identifier :head
  type :text

  def run(content, params={})
    # lines = content.match(/(.+)\n(.+)/)
    # @item[:name] = lines[1] + "bla"
    content.gsub(/(.+)\n(.+)/, '<h1>\1</h1><h2>\2</h2>')
  end
end

class AutolinkFilter < Nanoc3::Filter
  identifier :autolink
  type :text

  def run(content, params={})
    content = content.gsub(/([\w._-]+@\w+\.\w+)/, "<a href='mailto:\\1'>\\1</a>")
    content = content.gsub(/([\w_-]+\.\w+\.\w+)/, "<a href='http://\\1'>\\1</a>")
  end
end

class CoffeeFilter < Nanoc3::Filter
  identifier :coffee

  def run(content, params = {})
    CoffeeScript.compile(content)
  end
end
