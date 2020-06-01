# support for MEL catalog entries
require 'melcatalog'
require 'json'

class DocumentsController < ApplicationController
  before_filter :find_document, :only => [:show, :set_default_state, :preview, :post_to_cove, :annotatable, :review, :publish, :export, :archive, :snapshot, :destroy, :edit, :update]
  before_filter :authenticate_user!
  before_filter :set_relevant_users

  load_and_authorize_resource :except => [:create, :anthology_add]

  # GET /documents
  # GET /documents.json
  def anthology_add
    successful = true
    documents = []
    begin
      anthology = Anthology.find(params[:anthology])
      Rails.logger.info "****"
      Rails.logger.info "anthology is #{anthology.inspect}"
      params[:document_ids].each do |doc_id|
        doc = Document.find(doc_id)
        doc.rep_group_list.add(anthology.slug)
        doc.save
        unless anthology.documents.include?(doc)
          anthology.documents << doc
          documents << doc.title
        end
      end
      anthology.save
      Rails.logger.info "*** past save"
    rescue
      successful = false
    end
    respond_to do |format|
      if successful
        if documents.count == 1
          docs_string = " #{documents.first}"
        elsif documents.count == 2
          docs_string = "s #{documents.first} and #{documents.last}"
        elsif documents.count > 2
          docs_string = "s #{documents[ 0..-2 ].join(", ")} and #{documents.last}"
        end
        format.html { redirect_to anthology_path(Anthology.find(params[:anthology]), title: params[:title], author: params[:author]), notice: "You added the document#{docs_string} to this anthology" }
      else
        format.html { redirect_to documents_path, alert: "There was a problem adding documents to the anthology selected"}
      end
    end
    # redirect_to anthology_path(Anthology.first)
  end
  def index
    @anthologies = current_user.anthologies.map {|ant| ant.id}.uniq
    @anthologies = [@anthologies, Anthology.where(user_id: current_user.id).pluck(:id) ]
    @anthologies = @anthologies.flatten.uniq
    @anthologies = Anthology.all.map {|ant| ant if @anthologies.include?(ant.id)}
    @anthologies = @anthologies.compact
    if params[:anthology_id].present?
      @anthology = Anthology.find(params[:anthology_id])
    else
      @anthology = Anthology.first
    end
    @documents = []
    per_page = 20
    @search_documents_count = 0
    if ( params.has_key?(:author) || params.has_key?(:edition) || params.has_key?(:title) ) && !(params.has_key?(:docs))
      document_set = 'search_results'
    elsif params[:docs] != 'assigned' && params[:docs] != 'created' && params[:docs] != 'all' && params[:docs] != 'search_results' && params[:docs] != 'vetted'
      document_set = 'assigned'
    else
      document_set = params[:docs]
    end
    [:title, :author, :edition].each do |query|
      if params.has_key?(query) && params[query].present?
        if query == :edition
          @search_documents_count = Document.tagged_with(params[query]).count
        elsif params.has_key?(query) && params[query].present?
          @search_documents_count = Document.where("#{query} LIKE ?", "%#{params[query]}%").count
        end
      end
    end
    @vetted_documents_count = Document.where(vetted: true).count
    @tab_state = { document_set => 'active' }
    @assigned_documents_count = Document.active.tagged_with(current_user.rep_group_list, :any =>true).count
    @all_documents_count = Document.all.count
    @created_documents_count = current_user.documents.count
    if document_set == 'assigned'
      @documents = Document.active.tagged_with(current_user.rep_group_list, :any =>true).paginate(:page => params[:page], :per_page => per_page)
    elsif document_set == 'created'
      @documents = current_user.documents.paginate(:page => params[:page], :per_page => per_page)
    elsif document_set == 'vetted'
      @documents = Document.where(vetted: true).paginate(:page => params[:page], :per_page => per_page)
    elsif (can? :manage, Document) && document_set == 'all'
      @documents = Document.paginate(:page => params[:page], :per_page => per_page )
    elsif document_set == 'search_results'
      [:title, :author, :edition].each do |query|
        if params.has_key?(query) && params[query].present?
          if query == :edition
            @documents = Document.tagged_with(params[query])
          elsif params.has_key?(query) && params[query].present?
            @documents = Document.where("#{query} LIKE ?", "%#{params[query]}%")
          end
        end
      end
      if @documents.present?
        @documents = @documents.paginate(:page => params[:page], :per_page => per_page)
      else
        @documents = Document.paginate(:page => params[:page], :per_page => per_page ) 
        @search_documents_count = Document.count
      end
    end
    if @documents.present?
      if params[:order].present? && Document.column_names.include?(params[:order])
        if params[:order] == 'created_at'
          @documents = @documents.order('created_at DESC')
        else
          @documents = @documents.order(params[:order])
        end
      else
        @documents = @documents.order('created_at DESC')
      end
    end
    # add search parameters if they are there

    if params[:group]
      @documents = @documents.tagged_with(params[:group])
    end


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    # if request.path != document_path(@document)
    #   redirect_to @document, status: :moved_permanently
    # end

    # configuration for annotator [note that public schema won't have mel_catalog enabled]
    if params[:anthology_id].present?
      anthology = Anthology.find_by(slug: params[:anthology_id])
      @filtered_users = anthology.users.order(:firstname) if anthology.present?
    else
      @filtered_users = User.tagged_with(@document.rep_group_list, :any => true).order(:firstname)
    end
    @mel_catalog_enabled =  Tenant.mel_catalog_enabled
    @annotation_categories_enabled =  Tenant.annotation_categories_enabled
    @enable_rich_text_editor = ENV["ANNOTATOR_RICHTEXT"]
    @tiny_mce_toolbar = @mel_catalog_enabled ? ENV["ANNOTATOR_RICHTEXT_WITH_CATALOG"] : ENV["ANNOTATOR_RICHTEXT_CONFIG"]
    @api_url = ENV["API_URL"]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/1/preview
  def preview
    respond_to do |format|
      format.html # preview.html.erb
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @document = Document.new

    # list any catalogue texts as appropriate
    @catalog_texts = catalog_texts

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(documents_params)
    @document.user = current_user

    # apply any catalogue content as appropriate
    catalog_content(@document)

    respond_to do |format|
      if @document.save
        if params[:document][:upload].present?
          Delayed::Job.enqueue DocumentProcessor.new(@document.id, @document.state, Apartment::Database.current_tenant)
          @document.pending!
        end
        format.html { redirect_to documents_url(docs: 'created'), notice: 'Document was successfully created.', anchor: 'created'}
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.friendly.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(documents_params)
        format.html { redirect_to documents_url, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end

  #JSON for saving state
  def set_default_state
    @document.update_attribute(:default_state, params[:default_state])

    render :json => {}
  rescue Exception => e
    render :json => {}
  end

  def archive
    respond_to do |format|
      if @document.update_attribute(:state, 'archived')
        format.html { redirect_to documents_url, notice: 'Document was successfully archived.', anchor: 'created'}
      else
        format.html { render action: "edit" }
      end
    end
  end

  def annotatable

    respond_to do |format|
      if @document.update_attribute(:state, 'annotatable')
        format.html { redirect_to documents_url, notice: 'Document is now annotatable.', anchor: 'created'}
      else
        format.html { render action: "edit" }
      end
    end
  end

  def review

    respond_to do |format|
      if @document.update_attribute(:state, 'review')
        format.html { redirect_to documents_url, notice: 'Document is now reviewable.', anchor: 'created'}
      else
        format.html { render action: "edit" }
      end
    end
  end

  def publish
    # TODO: POST to COVE
    respond_to do |format|
      if @document.update_attribute(:state, 'published')
        format.html { redirect_to documents_url, notice: 'Document is now publishable.', anchor: 'created'}
      else
        format.html { render action: "edit" }
      end
    end
  end

  #Export HTML
  def export
    send_data(@document.snapshot, filename: "#{@document.title}.html")
  end

  #Snapshot of document for export
  def snapshot
    @document.update_attribute(:snapshot, params[:snapshot])
    render :json => {}
  rescue Exception => e
    render :json => {}
  end

  #POST document to COVE
  def post_to_cove
    document = {
      title: @document.title,
      body: { "und": [ { "value": @document.snapshot } ] },
      "type":"editions_page",
      format: "unfiltered_html",
      "field_doc_owner":{"und":[@document.user.cove_id]}
    }

    unauth_token = ApiRequester::CoveClient.get_unauth_session
    cookies = ApiRequester::CoveClient.get_cookie(unauth_token)
    login_token = ApiRequester::CoveClient.get_login_session(cookies)
    cove_object = ApiRequester::CoveClient.post(login_token, cookies, document)
    cove_hash = JSON.parse(cove_object)

    short_cove_uri = /editions\/api\/(node\/\d+)/.match(cove_hash["uri"])[1]

    @document.cove_uri = "#{ENV['COVE_URL']}/#{short_cove_uri}"

    @document.save!

    respond_to do |format|
      link = %Q[<a href="#{@document.cove_uri}" target="cove-edition">View it now</a>]
      format.html { redirect_to @document, notice: "Document was successfully posted to the COVE. #{link}".html_safe}
    end
  end

  # Helper which accepts an array of items and filters out those you are not allowed to read, according to CanCan abilities.
  # From Miximize.
  def filter_by_can_read(items)
    items.collect do |i|
      i unless cannot? :read, i
    end
  end

  def filter_by_samegroup(items)
    items.collect do |i|
      i unless cannot? :read, i
    end
  end

  before_filter :prepare_for_mobile

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
  end

  private

  def catalog_texts

    if catalogue_enabled?
      status, results = Melcatalog.texts
      return results[:text] unless results[:text].nil?
    end
    return []
  end

  def catalog_content( doc )

    if catalogue_enabled?
      # we put placeholder content in earlier and replace with the real thing now
      if doc.text.start_with?( "EID:" )
        eid = doc.text.split( ":",2 )[ 1 ]
        status, entry = Melcatalog.get( eid, 'stripxml' )
        if status == 200 && entry && entry[:text] && entry[:text][ 0 ] && entry[:text][ 0 ]['content']
          doc.text = entry[:text][ 0 ]['content']
        else
          doc.text = "Error getting document content from the catalog; status = #{status}, eid = #{eid}"
        end
      end
    end
  end

  private

  def catalog_texts

    if catalogue_enabled?
      status, results = Melcatalog.texts
      return results[:text] unless results[:text].nil?
    end
    return []
  end

  # helper to determine if we should support content from the MEL catalog
  def catalogue_enabled?
    Tenant.current_tenant.mel_catalog_enabled
  end

  def catalog_content( doc )

    if catalogue_enabled?
      # we put placeholder content in earlier and replace with the real thing now
      if doc.text.start_with?( "EID:" )
        eid = doc.text.split( ":",2 )[ 1 ]
        status, entry = Melcatalog.get( eid, 'stripxml' )
        if status == 200 && entry && entry[:text] && entry[:text][ 0 ] && entry[:text][ 0 ]['content']
          doc.text = entry[:text][ 0 ]['content']
        else
          doc.text = "Error getting document content from the catalog; status = #{status}, eid = #{eid}"
        end
      end
    end
  end

  private
  def find_document
    @document = Document.friendly.find(params.has_key?(:document_id) ? params[:document_id] : params[:id])
  end

  def set_relevant_users
    if @document.present?
      SwitchUser.setup {|config| config.available_users = {user: -> {User.tagged_with(@document.rep_group_list, :any => true).order(:firstname)}} }
      # @relevant_users = User.tagged_with(@document.rep_group_list, :any => true).order(:firstname)
    end
  end
  def documents_params
    params.require(:document).permit(:title, :state, :chapters, :text, :snapshot, :user_id, :rep_privacy_list,
                                     :rep_group_list, :new_group, :author, :edition, :publisher,
                                     :publication_date, :source, :rights_status, :upload, :survey_link, :vetted)
  end
end
