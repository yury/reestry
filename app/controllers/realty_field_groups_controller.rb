class RealtyFieldGroupsController < ApplicationController
  before_filter :admin_login_required
  
  # GET /realty_field_groups
  # GET /realty_field_groups.xml
  def index
    @realty_field_group = RealtyFieldGroup.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @realty_field_group }
    end
  end

  # GET /realty_field_groups/1
  # GET /realty_field_groups/1.xml
  def show
    @realty_field_group = RealtyFieldGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @realty_field_group }
    end
  end

  # GET /realty_field_groups/new
  # GET /realty_field_groups/new.xml
  def new
    @realty_field_group = RealtyFieldGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @realty_field_group }
    end
  end

  # GET /realty_field_groups/1/edit
  def edit
    @realty_field_group = RealtyFieldGroup.find(params[:id])
  end

  # POST /realty_field_groups
  # POST /realty_field_groups.xml
  def create
    @realty_field_group = RealtyFieldGroup.new(params[:realty_field_groups])

    respond_to do |format|
      if @realty_field_group.save
        flash[:notice] = 'RealtyFieldGroups was successfully created.'
        format.html { redirect_to(@realty_field_group) }
        format.xml  { render :xml => @realty_field_group, :status => :created, :location => @realty_field_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @realty_field_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /realty_field_groups/1
  # PUT /realty_field_groups/1.xml
  def update
    @realty_field_group = RealtyFieldGroup.find(params[:id])

    respond_to do |format|
      if @realty_field_group.update_attributes(params[:realty_field_groups])
        flash[:notice] = 'RealtyFieldGroups was successfully updated.'
        format.html { redirect_to(@realty_field_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @realty_field_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /realty_field_groups/1
  # DELETE /realty_field_groups/1.xml
  def destroy
    @realty_field_group = RealtyFieldGroup.find(params[:id])
    @realty_field_group.destroy

    respond_to do |format|
      format.html { redirect_to(realty_field_groups_url) }
      format.xml  { head :ok }
    end
  end
end
