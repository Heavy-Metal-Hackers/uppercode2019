class <%= class_name.pluralize %>Controller < ApplicationController
  load_and_authorize_resource

  # GET /<%= table_name %>
  # GET /<%= table_name %>.json
  def index
    @<%= table_name %> = @<%= table_name %>.where(active: true).order(:id).search(params[:search], params[:page])
  end

  # GET /<%= table_name %>/1
  # GET /<%= table_name %>/1.json
  def show
  end

  # GET /<%= table_name %>/new
  def new
  end

  # GET /<%= table_name %>/1/edit
  def edit
  end

  # POST /<%= table_name %>
  # POST /<%= table_name %>.json
  def create
    @<%= singular_table_name %> = <%= class_name %>.new(<%= singular_table_name %>_params)
    @<%= singular_table_name %>.create_user = current_user
    @<%= singular_table_name %>.update_user = current_user
    @<%= singular_table_name %>.active = true
    respond_to do |format|
      if @<%= singular_table_name %>.save
        #format.html { redirect_to <%= table_name %>_url, notice: "#{t('activerecord.models.<%= singular_table_name %>.one')} #{t('created_successfully')}." }
        format.html { redirect_to @<%= singular_table_name %>, notice: "#{t('activerecord.models.<%= singular_table_name %>.one')} #{t('created_successfully')}." }
        format.json { render action: 'show', status: :created, location: @<%= singular_table_name %> }
      else
        format.html { render action: 'new' }
        format.json { render json: @<%= singular_table_name %>.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /<%= table_name %>/1
  # PATCH/PUT /<%= table_name %>/1.json
  def update
    @<%= singular_table_name %>.update_user = current_user
    respond_to do |format|
      if @<%= singular_table_name %>.update(<%= singular_table_name %>_params)
        #format.html { redirect_to <%= table_name %>_url, notice: "#{t('activerecord.models.<%= singular_table_name %>.one')} #{t('updated_successfully')}." }
        format.html { redirect_to @<%= singular_table_name %>, notice: "#{t('activerecord.models.<%= singular_table_name %>.one')} #{t('updated_successfully')}." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @<%= singular_table_name %>.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /<%= table_name %>/1
  # DELETE /<%= table_name %>/1.json
  def destroy
    @<%= singular_table_name %>.active = false
    @<%= singular_table_name %>.update_user = current_user
    @<%= singular_table_name %>.save
    respond_to do |format|
      format.html { redirect_to <%= table_name %>_url }
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def <%= singular_table_name %>_params
      params.require(:<%= singular_table_name %>).permit(<%= ((attributes - ["create_user", "update_user"]).map { |a| ":#{a.name}"}).join(", ") %>)
    end
end
