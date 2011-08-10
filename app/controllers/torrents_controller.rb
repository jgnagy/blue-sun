class TorrentsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def add_comment
    @torrent = Torrent.find(params[:id])
    @comment = params[:comment]
    
    @torrent.tags << Comment.find_or_create_by_name(@comment, :user_id => current_user.id)
    @torrent.save
    
    respond_to do |format|
      format.html { render :partial => "torrent" }
      format.xml  { render :xml => @torrent }
      format.json  { render :json => @torrent }
    end
  end
  
  def create
    @torrent = Torrent.new(params[:torrent])
    @torrent.user_id = current_user.id
    
    respond_to do |format|
      if @torrent.save
        # TODO: perform some indexing in SOLR / lucene / sphinx at some point
        # TODO: add a hash of the file
        format.html { redirect_to(@torrent, :notice => 'Torrent was successfully created.') }
        format.xml { render :xml => @torrent, :status => :created, :location => @torrent }
        format.json { render :json => @torrent, :status => :created, :location => @torrent }
      else
        format.html { render(:action => 'new') }
        format.xml { render :xml => @torrent.errors, :status => :unprocessable_entity }
        format.json { render :json => @torrent.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @torrent = Torrent.find(params[:id])
    @torrent.destroy
    
    respond_to do |format|
      format.html { redirect_to(torrents_url) }
      format.xml { head :ok }
      format.json { head :ok }
    end
  end
  
  def download
    @torrent = Torrent.find(params[:id])
    send_file @torrent.filename.current_path
  end
  
  def index
    @intro_text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut."
    @torrents = Torrent.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @torrents }
      format.json  { render :json => @torrents }
    end
  end
  
  def new
    @torrent = Torrent.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @torrent }
      format.json  { render :json => @torrent }
    end
  end
  
  def search
    @query = params[:q]
    if @query and @query != "all"
      #@torrents = Torrent.where("torrents.name LIKE :query", { :query => "%#{@query}%" })
      @torrents = Torrent.search do
        keywords params[:q]
      end
    else
      @torrents = Torrent.all
    end
    
    respond_to do |format|
      format.html # search.html.erb
      format.xml  { render :xml => @torrents }
      format.json  { render :json => @torrents }
    end
  end
  
  def show
    @torrent = Torrent.find(params[:id])
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @torrent }
      format.json  { render :json => @torrent }
    end
  end
  
  def update
    @torrent = Torrent.find(params[:id])
    
    respond_to do |format|
      if @torrent.update_attributes(params[:torrent])
        # TODO: perform some indexing in SOLR / lucene / sphinx at some point
        format.html { redirect_to(@torrent, :notice => 'Torrent was successfully updated.') }
        format.xml { render :xml => @torrent, :status => :created, :location => @torrent }
        format.json { render :json => @torrent, :status => :created, :location => @torrent }
      else
        format.html { render(:action => 'edit') }
        format.xml { render :xml => @torrent.errors, :status => :unprocessable_entity }
        format.json { render :json => @torrent.errors, :status => :unprocessable_entity }
      end
    end
  end
end
