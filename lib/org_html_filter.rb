module Nanoc::Filters
  class OrgHtmlFilter < Nanoc::Filter
    identifier :org_html_filter
    type :text
    require 'nokogiri'

    def run(content, params = {})
      # body_content = 
      html_doc = Nokogiri::HTML(content)
      html_doc.xpath('//*[@id = "postamble"]').remove
      html_doc.xpath('//h1').remove
      # html_doc.xpath('//div[@class="figure"]').remove
      html_doc.xpath('//img').each do |node|
        new_a_node = Nokogiri::XML::Node.new('a', html_doc)
        new_a_node['href'] = node['src']
        new_a_node['title'] = node['alt']
        new_a_node['class'] = 'fancybox'
        new_a_node['rel'] = 'group'
        new_a_node.parent = node.parent
        node.parent = new_a_node
      end
      body_content = /<body>(.*)<\/body>/m.match(html_doc.to_html)[1]
    end

  end
end
