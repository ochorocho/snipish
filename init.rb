
Redmine::Plugin.register :snipish do
  name 'Snipish plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
  ### JOCHEN
  #permission :polls, { :polls => [:index, :vote] }, :public => true
  permission :view_snipish, :snipish => :index, :require => :member
  permission :add_snipish, :snipish => :add, :require => :member
  
  menu :top_menu, :snipish, { :controller => 'snip', :action => 'index' }, :caption => :snipish_menu, :if => Proc.new { 
	  User.current.logged?
  }
  settings :default => {'empty' => true}, :partial => 'settings/snipish'
end

#require 'redmine'

# hooks
require 'snipish/hooks/view_layouts_base_html_head_hook'