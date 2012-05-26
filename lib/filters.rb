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
