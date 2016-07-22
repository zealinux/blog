# coding: utf-8
module Nanoc::Filters
  class OrgModeHtml < Nanoc::Filter
    identifier :org2html

    require 'org-ruby'
    type :text

    def run(content, params = {})
      org_content = content + '#+OPTIONS: author:t H:2 num:t todo:t'
      ::Orgmode::Parser.new(org_content).to_html
    end
  end
end
