require 'will_paginate/array'

class SnipController < ApplicationController
  unloadable

  def index

	#### USER PERMISSION HACK
	@usersGroup = User.current.groups.all
	@usersGroup.each do |group|

		@settings = Setting.plugin_snipish["snipish_group"]
		@groupIds = []
		if @settings.nil?
			@UserAllowed = 'false'
		else
			@settings = Setting.plugin_snipish["snipish_group"]["#{group.id}"]
			if @settings.blank?
				@UserAllowed = 'false'
			else 
				@UserAllowed = 'true'
				@groupIds << group.id
			end
		end			
	end

	if params[:per_page].nil?
		params[:per_page] = '50'
	end

	if params[:tag].nil?
		@snips = Snip.find(:all, :order => 'last_modified DESC').paginate(:page => params[:page], :per_page => params[:per_page])
	else
		@snips = Snip.find(:all, :conditions => ["tag LIKE ?", "%" + params[:tag] + "%"], :order => 'last_modified DESC').paginate(:tag => params[:tag], :page => params[:page], :per_page => params[:per_page])
	end

	@latest = Snip.find(:all, :order => 'last_modified DESC', :limit => 10)
	
	@snippers = Snip.paginate(:page => params[:page], :per_page => params[:per_page])
	
  end

  def detail
	
	@detail = Snip.find(params[:item])	
	
	@tags = '<ul class="detailTags tagit ui-widget ui-widget-content ui-corner-all"><h3>' + l(:snipish_add_tag) + '</h3>'
	@singleTag = @detail.tag.to_s.split(/,/)
	@singleTag.each do |single|
	   @tags += '<li class="tagit-choice ui-widget-content ui-state-default ui-corner-all tagit-choice-read-only"><a href="' + url_for(:controller => "snip", :action => "index", :tag => single.to_s) +  '">' + single.to_s + '</a></li>'
	end
	@tags += '</ul>'


	@changeset = '<ul class="detailRefs tagit ui-widget ui-widget-content ui-corner-all"><h3>' + l(:snipish_add_ref) + '</h3>'
	@singleChange = @detail.ref.to_s.split(/,/)
	@singleChange.each do |single|
	   @codeDetails = Changeset.find(single)
	   @getRepo = Repository.find(@codeDetails.repository_id)
	   @getProject = Project.find(@getRepo.project_id)
	   @changeset += '<li class="tagit-choice ui-widget-content ui-state-default ui-corner-all tagit-choice-read-only"><a title="' + @codeDetails.comments + '" href="' + url_for(:controller => 'repositories', :action => 'revision', :id => @getProject.id, :repository_id => @codeDetails.repository_id, :rev => @codeDetails.revision) +  '">' + @codeDetails.comments.truncate(16, omission: '..') + '</a></li>'
	end
	@changeset += '</ul>'

	
	@json = {'id' => @detail.id, 'name' => @detail.name, 'description' => @detail.description, 'tag' => @tags, 'codetype' => @detail.codetype, 'author' => @detail.author, 'code' => @detail.code, 'ref' => @changeset}
	
	render json: @json
  end

  def add
	#### USER PERMISSION HACK
	@usersGroup = User.current.groups.all
	@usersGroup.each do |group|

		@settings = Setting.plugin_snipish["snipish_group"]
		@groupIds = []
		if @settings.nil?
			@UserAllowed = 'false'
		else
			@settings = Setting.plugin_snipish["snipish_group"]["#{group.id}"]
			if @settings.blank?
				@UserAllowed = 'false'
			else 
				@UserAllowed = 'true'
				@groupIds << group.id
			end
		end			
	end

	@snip = Snip.new
	@latest = Snip.find(:all, :order => 'last_modified DESC', :limit => 10)
  end

  def edit
	#### USER PERMISSION HACK
	@usersGroup = User.current.groups.all
	@usersGroup.each do |group|

		@settings = Setting.plugin_snipish["snipish_group"]
		@groupIds = []
		if @settings.nil?
			@UserAllowed = 'false'
		else
			@settings = Setting.plugin_snipish["snipish_group"]["#{group.id}"]
			if @settings.blank?
				@UserAllowed = 'false'
			else 
				@UserAllowed = 'true'
				@groupIds << group.id
			end
		end			
	end

	@edit = Snip.find(params[:item])
	@latest = Snip.find(:all, :order => 'last_modified DESC', :limit => 10)
  end

  def saveedit
	@snip = Snip.find(params[:item])
	@snip.name = params[:snip][:name]
	@snip.description = params[:snip][:description]
	@snip.code = params[:snip][:code]
	@snip.codetype = params[:snip_codetype]
	@snip.ref = params[:snip][:ref]
	@snip.tag = params[:snip][:tag]
	@snip.last_modified_by = User.current.name
	@snip.last_modified = Time.now
	@snip.save
	redirect_to action: 'index', status: :found
	flash[:notice] = params[:snip][:name]
  end

  def delete

	@snip = Snip.find(params[:item])
	@snip.delete
	redirect_to action: 'index', status: :found
	flash[:notice] = 'Deleted'
  end

  def save	
	@snip = Snip.new(params[:snip])
	@snip.name = params[:snip][:name]
	@snip.description = params[:snip][:description]
	@snip.code = params[:snip][:code]
	@snip.tag = params[:snip][:tag]
	@snip.codetype = params[:snip_codetype]
	@snip.ref = params[:snip][:ref]
	@snip.author = User.current.name
	@snip.last_modified_by = User.current.name
	@snip.last_modified = Time.now
	@snip.save
	redirect_to action: 'index', status: :found
	flash[:notice] = params[:snip][:name]
  end
### SEARCH
  def search

	@term = params[:term]
	@snips = Snip.find(:all, :conditions => ["name LIKE ? or description LIKE ? or code LIKE ?", "%" + @term + "%", "%" + @term + "%", "%" + @term + "%"])
	
	@json = []
	@snips.each do |snippet|
	   @value = {'value' => snippet.name, 'label' => snippet.name, 'desc' => snippet.description, 'type' => snippet.codetype, 'id' => snippet.id}
	   @json.push(@value)
	end

	render json: @json
  end

  def searchrefs

	@term = params[:term]
	@changesets =  Changeset.find(:all, :order => 'committed_on DESC', :conditions => ["committer LIKE ? or comments LIKE ? or id LIKE ?", "%" + @term + "%", "%" + @term + "%", "%" + @term + "%"])
	
	@json = []
	@changesets.each do |change|
	   @value = {'label' => change.id, 'value' => change.id, 'committer' => change.committer, 'comment' => change.comments}
	   @json.push(@value)
	end

	render json: @json
  end


  def searchtags

	@term = params[:term]
	@tags = Snip.find(:all, :conditions => ["tag LIKE ?", "%" + @term + "%"])
	
	@json = []
	@tags.each do |tag|
	   @single = tag.tag.to_s.split(/,/)
	   @single.each do |single|
		   @value = {'value' => single, 'label' => single}
		   @json.push(@value)
	   end
	end

	render json: @json
  end

end