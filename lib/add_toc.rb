module NanocSite
  # TODO(zy): Very ugly code, I think. This is my first time to use Ruby.
  class AddTOCFilter < Nanoc::Filter

    identifier :add_toc

    # TODO: 
    def run(content, params={})
      # TODO(zy): Very ugly code, I think. This is my first time to use Ruby.
      html_doc = Nokogiri::HTML(content)
      headers = ['h2', 'h3']
      headers_count = [0, 0]
      last_header_level = 1
      toc = Nokogiri::XML('')
      toc = Nokogiri::XML::Node.new('nav', toc)
      toc['class'] = "notes-sidebar  hidden-xs hidden-sm"
      toc['id'] = "notes-sidebar"

      cur_toc_node = toc
      html_doc.xpath('//h2|//h3').each_with_index do |header, i|
        name = header.name
        header_level = name[1..-1].to_i
        index = headers.index(name)
        headers_count[index] += 1
        id = ''
        headers_count.each_with_index do |count, j|
          if count <= 0
            next
          elsif j > index
            headers_count[j] = 0
          else
            id += count.to_s + '.'
          end
        end

        # TODO(zy): Very ugly code, I think. This is my first time to use Ruby.
        if header_level > last_header_level
          toc_ul = Nokogiri::XML::Node.new('ul', toc)
          if i == 0
            toc_ul['class'] = "nav nav-stacked fixed"
            cur_toc_node.add_child(toc_ul)
          else
            toc_ul['class'] = "nav nav-stacked"
            cur_toc_node.add_child(toc_ul)
          end
          cur_toc_node = toc_ul

          new_li_node = Nokogiri::XML::Node.new('li', toc)
          new_a_node = Nokogiri::XML::Node.new('a', toc)
          new_a_node["href"] = '#' + header["id"]
          new_a_node.content = header.content
          new_li_node.add_child(new_a_node)
          cur_toc_node.add_child(new_li_node)
          cur_toc_node = new_li_node
        elsif header_level == last_header_level
          new_li_node = Nokogiri::XML::Node.new('li', toc)
          new_a_node = Nokogiri::XML::Node.new('a', toc)
          new_a_node["href"] = '#' + header["id"]
          new_a_node.content = header.content
          new_li_node.add_child(new_a_node)
          cur_toc_node.add_next_sibling(new_li_node)
          cur_toc_node = new_li_node
        else
          new_li_node = Nokogiri::XML::Node.new('li', toc)
          new_a_node = Nokogiri::XML::Node.new('a', toc)
          new_a_node["href"] = '#' + header["id"]
          new_a_node.content = header.content
          new_li_node.add_child(new_a_node)

          cur_toc_node = cur_toc_node.xpath('..')[0]
          cur_toc_node = cur_toc_node.xpath('..')[0]
          cur_toc_node = cur_toc_node.xpath('..')[0]
          cur_toc_node.add_child(new_li_node)
          cur_toc_node = new_li_node
        end

        last_header_level = header_level
      end
      content = html_doc.to_html

      # toc.xpath('//ul').each do |ul|
      # ul["id"] = "sidebar"
      # end
      content.gsub('{{ TOC }}') do
        toc.to_html
      end
    end

  end

end
