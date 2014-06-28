# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'snipish', :controller => 'snip', :action => 'index'
get 'snipish_search', :controller => 'snip', :action => 'search'
post 'snipish_detail', :controller => 'snip', :action => 'detail'
get 'snipish_searchtags', :controller => 'snip', :action => 'searchtags'
get 'snipish_searchrefs', :controller => 'snip', :action => 'searchrefs'
get 'snipish_edit', :controller => 'snip', :action => 'edit'
get 'snipish_add', :controller => 'snip', :action => 'add'
get 'snipish_save', :controller => 'snip', :action => 'save'
post 'snipish_delete', :controller => 'snip', :action => 'delete'
get 'snipish_saveedit', :controller => 'snip', :action => 'saveedit'
