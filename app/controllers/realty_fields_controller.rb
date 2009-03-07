class RealtyFieldsController < ApplicationController
  before_filter :admin_login_required
  
  # GET /realty_fields
  # GET /realty_fields.xml
  def index
    @realty_fields = RealtyField.find(:all)
    @realty_types = RealtyType.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @realty_fields }
    end
  end


  # GET /realty_fields/new
  # GET /realty_fields/new.xml
  def new
    @realty_field = RealtyField.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @realty_field }
    end
  end

  # GET /realty_fields/1/edit
  def edit
    @realty_field = RealtyField.find(params[:id])
  end
  
  def edit_list
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @realty_field }
    end
  end

  # POST /realty_fields
  # POST /realty_fields.xml
  def create
    @realty_field = RealtyField.new(params[:realty_field])
    save_realty_field_settings @realty_field

    respond_to do |format|
      if @realty_field.save
        flash[:notice] = 'RealtyField was successfully created.'
        format.html {  redirect_to(realty_fields_url) }
        format.xml  { render :xml => @realty_field, :status => :created, :location => @realty_field }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @realty_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /realty_fields/1
  # PUT /realty_fields/1.xml
  def update
    @realty_field = RealtyField.find(params[:id])
    save_realty_field_settings @realty_field

    respond_to do |format|
      if @realty_field.update_attributes(params[:realty_field])
        flash[:notice] = 'RealtyField was successfully updated.'
        format.html {  redirect_to(realty_fields_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @realty_field.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /realty_fields/1
  # DELETE /realty_fields/1.xml
  def destroy
    @realty_field = RealtyField.find(params[:id])
    @realty_field.destroy

    respond_to do |format|
      format.html { redirect_to(realty_fields_url) }
      format.xml  { head :ok }
    end
  end
  
private
  def save_realty_field_settings realty_field
      realty_field.realty_field_settings.destroy_all 
      
      for key in params.keys
        if key.starts_with?("realty_type")
          realty_type_id = key.split(".")[1]
          service_type_id = params["service_type.#{realty_type_id}"]

          realty_field.realty_field_settings << RealtyFieldSetting.new(
            :realty_type_id => realty_type_id, :service_type_id => service_type_id)
        end
      end
  end
end
