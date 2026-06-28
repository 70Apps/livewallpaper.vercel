module Jekyll
  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')
      self.data['tag'] = tag
      self.data['title'] = "Tag: #{tag}"
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      tags_dir = 'tag'
      all_tags = collect_all_tags(site)

      # Expose aggregated tags to Liquid templates (sorted alphabetically)
      site.config['all_tags'] = all_tags.sort.to_h.transform_values { |docs| docs.size }

      all_tags.each_key do |tag|
        site.pages << TagPage.new(site, site.source, File.join(tags_dir, tag), tag)
      end
    end

    private

    def collect_all_tags(site)
      tags = Hash.new { |hash, key| hash[key] = [] }

      collections_to_scan = ['posts', 'iphone-wallpaper', 'ipad-wallpaper']

      collections_to_scan.each do |collection_name|
        docs = if collection_name == 'posts'
                 site.posts.docs
               else
                 site.collections[collection_name]&.docs || []
               end

        docs.each do |doc|
          doc_tags = doc.data['tags']
          next if doc_tags.nil?

          tag_list = doc_tags.is_a?(Array) ? doc_tags : [doc_tags]
          tag_list.each do |tag|
            tag_str = tag.to_s.strip
            next if tag_str.empty?
            tags[tag_str] << doc
          end
        end
      end

      tags
    end
  end
end
