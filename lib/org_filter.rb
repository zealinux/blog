# coding: utf-8
module Nanoc::Filters
  class OrgModeHtml < Nanoc::Filter
    identifier :org2html

    require 'org-ruby'
    type :text

    def run(content, params = {})
      ::Orgmode::Parser.new(content).to_html
    end
  end
end