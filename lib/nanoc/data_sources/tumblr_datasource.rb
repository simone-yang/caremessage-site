require 'json'
require 'time'
require 'open-uri'

module Nanoc::DataSources

  class TumblrDataSource < Nanoc::DataSource

    identifier :tumblr

  def items

    @items ||= begin

        if self.config[:name].nil?
          raise RuntimeError, "It is required to define a name for data source."
        end

        # Parse data
        filename = "tmp/caremessage-tumblr.json"
        if !File.file?(filename)
          raise RuntimeError, "No data (#{filename} does not exist)"
        end
        data = open("http://#{self.config[:name]}.tumblr.com/api/read/json?debug=1").read
        raw_items = JSON.parse(data)

        raw_items['posts'].each_with_index.map do | raw_item, i |

        content = raw_item['regular-body']
          attributes = {
            :title => raw_item['regular-title'],
            :content => raw_item['regular-body'],
            :created_at => Time.at(raw_item['unix-timestamp'] / 1000),

          }
          id = "/blog/entries/#{raw_item['slug']}/"

          mtime = Time.at(raw_item['unix-timestamp'] / 1000)

          # TODO: define correct attributes
          Nanoc::Item.new(content, attributes, id, mtime)
        end

    end
  end

  end
end

