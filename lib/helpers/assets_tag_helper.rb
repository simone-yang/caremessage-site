module AssetsTagHelper
  BOOLEAN_ATTRIBUTES = %w(disabled readonly multiple checked autobuffer
                       autoplay controls loop selected hidden scoped async
                       defer reversed ismap seamless muted required
                       autofocus novalidate formnovalidate open pubdate
                       itemscope allowfullscreen default inert sortable
                       truespeed typemustmatch).to_set

  BOOLEAN_ATTRIBUTES.merge(BOOLEAN_ATTRIBUTES.map {|attribute| attribute.to_sym })

  PRE_CONTENT_STRINGS = {
    :textarea => "\n"
  }

  def content_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)
    if block_given?
      options = content_or_options_with_block if content_or_options_with_block.is_a?(Hash)
      content_tag_string(name, capture(&block), options, escape)
    else
      content_tag_string(name, content_or_options_with_block, options, escape)
    end
  end

  def video_tag(*sources)
    multiple_sources_tag('video', sources) do |options|
      options[:poster] = path_to_image(options[:poster]) if options[:poster]
      options[:width], options[:height] = extract_dimensions(options.delete(:size)) if options[:size]
    end
  end

  def image_tag(source, options={})
    options = options.symbolize_keys

    src = options[:src] = path_to_image(source)

    if size = options.delete(:size)
      options[:width], options[:height] = size.split("x") if size =~ %{\A\d+x\d+\z}
      options[:width] = options[:height] = size if size =~ %{\A\d+\z}
    end

    tag("img", options)
  end

  private
  def multiple_sources_tag(type, sources)
    options = sources.extract_options!.symbolize_keys
    sources.flatten!

    yield options if block_given?

    if sources.size > 1
      content_tag(type, options) do
        safe_join sources.map { |source| tag("source", :src => send("path_to_#{type}", source)) }
      end
    else
      options[:src] = send("path_to_#{type}", sources.first)
      content_tag(type, nil, options)
    end
  end

  def path_to_video(source)
    "/images/#{source}"
  end

  def path_to_image(source)
    "/images/#{source}"
  end

  def content_tag_string(name, content, options, escape = true)
    tag_options = tag_options(options, escape) if options
    content     = ERB::Util.h(content) if escape
    "<#{name}#{tag_options}>#{PRE_CONTENT_STRINGS[name.to_sym]}#{content}</#{name}>"
  end

  def tag(name, options = nil, open = false, escape = true)
    "<#{name}#{tag_options(options, escape) if options}#{open ? ">" : " />"}"
  end

  def tag_options(options, escape = true)
    return if options.nil? || options.empty?
    attrs = []
    options.each_pair do |key, value|
      if key.to_s == 'data' && value.is_a?(Hash)
        value.each_pair do |k, v|
          attrs << data_tag_option(k, v, escape)
        end
      elsif BOOLEAN_ATTRIBUTES.include?(key)
        attrs << boolean_tag_option(key) if value
      elsif !value.nil?
        attrs << tag_option(key, value, escape)
      end
    end
    " #{attrs.sort! * ' '}" unless attrs.empty?
  end

  def boolean_tag_option(key)
    %(#{key}="#{key}")
  end

  def tag_option(key, value, escape)
    value = value.join(" ") if value.is_a?(Array)
    value = h(value.to_s) if escape
    %(#{key}="#{value}")
  end
end