# coding: utf-8
require 'nokogiri'

module Nanoc::Filters
  class CorrectHtmelFilter < Nanoc::Filter
    identifier :correct_html

    type :html

    def run(content, params = {})
      doc = Nokogiri::HTML.parse(content)
      node = doc.css 'article > h1.title'
      title = node.text
      node.remove

      doc.at_css('header h1').content = title

      # H1~H6降级
      6.downto(1).each do |num|
        doc.css("article h#{num}").each do |h|
          h.name = 'h' + (num + 1).to_s
          # for TOC
          h['id'] = 'sec-' + h.first_element_child.content.gsub('.', '-')
        end
      end

      doc.to_html
    end
  end
end
