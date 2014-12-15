require 'nanoc/cachebuster'

include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Filtering
include Nanoc3::Helpers::LinkTo
include Nanoc::Helpers::CacheBusting

module TraversalHelper
  DIR = '[^/]+/'
  def more_link
    more = @item.path+'mehr/'
    "<p><a class='detail' href='#{more}'>[mehr]</a>"
  end

  def image?(item)
    ['jpg', 'png', 'gif'].include? item[:extension]
  end

  def first_image_for(item)
    if item && item.children
      (img = item.children.detect{|i| image?(i) }) ? img.path : nil
    end
  end

  def first_child_item(identifier, no_redirect=true)
    childs = @items.select{|i| i.identifier =~ %r{^#{identifier}[^/]+/$}}
    childs = childs.reject{|i| i[:redirect] } if no_redirect
    sorted(childs).first
  end

  def first_image_named_for(item, name)
    (img = item.children.detect{|i| image?(i) && i.identifier =~ /#{name}/ }) ? img.path : nil
  end

  def images_named_for(item, name)
    item.children.select{|i| image?(i) && i.identifier =~ /#{name}/ }
  end

  def vimeo_link(item)
    if vimeo_id = item[:vimeo]
      "http://player.vimeo.com/video/#{vimeo_id}?api=1"
    end
  end

  def vimeo_frame
    if link = vimeo_link(@item)
      "<iframe class='vimeoframe' src='#{link}' frameborder='0' webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>"
    end
  end

  # returns a string usable as html id
  def identifier_class(item)
    item.identifier.gsub(/^\//, '').gsub(/\/$/,'').gsub(/\//,'-')
  end

  def sorted(items)
    items.sort{|p1, p2| (p2[:prio] || 0) <=> (p1[:prio] || 0) }
  end

  def sorted_siblings(item, no_redirect=true)
    pseudo_parent = item.identifier.gsub(%r{#{DIR}$}, '')
    siblings = @items.select{|i| i.identifier =~ %r{^#{pseudo_parent}#{DIR}$}}
    siblings = siblings.reject{|i| i[:redirect]} if no_redirect
    sorted(siblings)
  end

  def sorted_contents(item)
    contents = @items.select{|i| i.identifier =~ %r{^#{item.identifier}#{DIR}$}}
    sorted(contents)
  end

  def sorted_sub_contents(item)
    contents = @items.select{|i| i.identifier =~ %r{^#{item.identifier}#{DIR}#{DIR}$}}
    sorted(contents)
  end

  def sorted_children(item, no_redirect=true)
    childs = item.children
    childs = childs.reject{|i| i[:redirect] } if no_redirect
    sorted(childs)
  end

  def first_child_identifier(item)
    return nil if item.children.size == 0
    sorted_children(item).first.identifier
  end

  def title_for(item)
    (n = item[:name]) ? "#{@config[:site]}: #{n}" : @config[:site]
  end

  def exists?(identifier)
    !!@items.find{|i| i.identifier == identifier}
  end

end
include TraversalHelper

module LanguageHelper
  def language_code_of(item)
    (item.identifier.match(/^\/([a-z]{2})\//) || [])[1]
  end

  def translations_of(item)
    translations = {}
    @items.each do |i|
      if i.identifier.slice(3..-1) == item.identifier.slice(3..-1)
        translations[language_code_of(i)] = i
      end
    end
    translations
  end

  def current_language
    language_code_of(@item)
  end

  def current_shortpath?(shortpath)
    !!(@item.identifier =~ /^(\/..)?\/#{shortpath.size > 0 ? "#{shortpath}/" : '$'}/)
  end

  def path_for_shortpath(shortpath)
    identifier = "/#{current_language}/#{shortpath}/".gsub(/\/+/, '/')
    identifier = "/de/#{shortpath}/".gsub(/\/+/, '/') unless exists?(identifier)
    identifier
  end

end
include LanguageHelper
