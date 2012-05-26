include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Filtering
include Nanoc3::Helpers::LinkTo

module MoreLinkHelper
  def more_link
    more = @item.path.gsub /\/$/, '_mehr/'
    "<p><a class='detail' href='#{more}'>[mehr]</a>"
  end
end

include MoreLinkHelper
