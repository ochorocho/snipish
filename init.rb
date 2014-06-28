
Redmine::Plugin.register :snipish do
  name 'Snipish plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  menu :top_menu, :snipish, { :controller => 'snip', :action => 'index' }, :caption => :snipish_menu, :if => Proc.new { 
  	!User.current.allowed_to?(:commit_access, :global => true).nil?
  }
end

require 'snipish/hooks/view_layouts_base_html_head_hook'