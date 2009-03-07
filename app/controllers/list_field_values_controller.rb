class ListFieldValuesController < ApplicationController
  before_filter :admin_login_required
  
  # GET /list_field_values
  # GET /list_field_values.xml
  def index
    @list_field_values = ListFieldValue.find(:all, :order => "realty_field_id")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @list_field_values }
    end
  end

  # GET /list_field_values/1
  # GET /list_field_values/1.xml
  def show
    @list_field_value = ListFieldValue.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @list_field_value }
    end
  end

  # GET /list_field_values/new
  # GET /list_field_values/new.xml
  def new
    @list_field_value = ListFieldValue.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @list_field_value }
    end
  end

  # GET /list_field_values/1/edit
  def edit
    @list_field_value = ListFieldValue.find(params[:id])
  end

  # POST /list_field_values
  # POST /list_field_values.xml
  def create
    @list_field_value = ListFieldValue.new(params[:list_field_value])

    respond_to do |format|
      if @list_field_value.save
        flash[:notice] = 'ListFieldValue was successfully created.'
        format.html { redirect_to(list_field_values_url) }
        format.xml  { render :xml => @list_field_value, :status => :created, :location => @list_field_value }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @list_field_value.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /list_field_values/1
  # PUT /list_field_values/1.xml
  def update
    @list_field_value = ListFieldValue.find(params[:id])

    respond_to do |format|
      if @list_field_value.update_attributes(params[:list_field_value])
        flash[:notice] = 'ListFieldValue was successfully updated.'
        format.html { redirect_to(list_field_values_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @list_field_value.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /list_field_values/1
  # DELETE /list_field_values/1.xml
  def destroy
    @list_field_value = ListFieldValue.find(params[:id])
    @list_field_value.destroy

    respond_to do |format|
      format.html { redirect_to(list_field_values_url) }
      format.xml  { head :ok }
    end
  end
end
