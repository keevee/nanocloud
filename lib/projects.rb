class Project
  @@projects = []
  @@categories = []

  class << self

    def process_items(items, categories)
      @@projects    = []
      @@categories  = categories
      @@cat_keys    = @@categories.map{|c| c[:key].to_sym}

      # add items with category to projects list
      items.each do |it|
        add(it) if (cat_key = it[:category]) && (@@cat_keys.include? cat_key.to_sym)
      end

      # add category lists
      items.each do |it|
        if cat_key = it[:category]
          it[:project_list] = by_category(cat_key)
        end
      end
    end

    def add (item)
      throw "#{item.identifier} no category or name"                  unless item[:category] && item[:name]
      throw "#{item.identifier} unknown category #{item[:category]}"  unless (category = categories.find{|cat| cat[:key] == item[:category].to_sym})
      item[:cat_name] = category[:name]
      item[:image]    = lambda {(img = item.children.detect{|i| i[:extension] == 'jpg'}) ? img.path : nil}
      @@projects << item
    end

    def all
      @@projects
    end

    def by_category(cat_key)
      pros = cat_key == :all ? all : all.select{|pro| pro[:category] == cat_key}

      pros.sort do |a,b|
        ca = @@cat_keys.index a[:category]
        cb = @@cat_keys.index b[:category]
        ra = a[:rank] || 0
        rb = b[:rank] || 0
        (ca == cb) ? rb <=> ra : ca <=> cb
      end
    end

    def categories
      @@categories.map do |cat|
        key = cat[:key].to_sym
        cat.merge({
          :key  => key,
          :path => (f = by_category(key).first) && begin f.path rescue nil end
        })
      end
    end

  end
end
