include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Filtering
include Nanoc3::Helpers::LinkTo

module MoreLinkHelper
  def more_link
    more = @item.path.gsub /\/$/, '_mehr/'
    "<p><a class='detail' href='#{more}'>[mehr]</a>"
  end

  def image_for(item)
    (img = item.children.detect{|i| i[:extension] == 'jpg'}) ? img.path : nil
  end
end

include MoreLinkHelper
