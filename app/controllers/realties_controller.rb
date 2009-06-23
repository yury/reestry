class RealtiesController < ApplicationController
  before_filter :login_required, :only => [ :new, 
                                            :create
                                          ]
                                          
  before_filter :check_access, :only => [
                                            :update_realty_type, 
                                            :photos, 
                                            :contacts, 
                                            :edit,
                                            :update,
                                            :destroy,
                                            :delete_photo
                                            ]

  def home
    redirect_to "/home.html"
  end

  # GET /realties
  # GET /realties.xml
  def index
    params[:service] = 1 if params[:service].blank?

    @pars = params
    @realties = Realty.select params
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @realties }
    end
  end

  # GET /realties/1
  # GET /realties/1.xml
  def show
    @realty = Realty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @realty }
    end
  end

  # GET /realties/new
  # GET /realties/new.xml
  def new
    @realty = Realty.new(:realty_type => RealtyType.first, :service_type => ServiceType.first)
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @realty }
    end
  end
  
  def update_realty_fields
    respond_to do |format|
      if(params[:is_search])
        format.js { render :partial => "search_realty_fields", :locals => {:realty_type_id => params[:realty_type_id], :service_type_id => params[:service_type_id].to_i} }
      elsif
        @realty = Realty.new(:realty_type_id => params[:realty_type_id], :service_type_id => params[:service_type_id]) 
        format.js { render :partial => "realty_fields", :locals => {:realty => @realty} }
      end  
    end
  end
  
  def update_realty_district
    respond_to do |format|
      format.js { render :text => {:html => render_to_string(:partial => "realty_district_select",
           :locals => {:is_search => params[:is_search], :location_id => params[:location_id]}),
           :hide_place => params[:location_id].blank? || Location.find(params[:location_id]).is_place}.to_json
      }
    end
  end
  
  def photos
    @realty = Realty.find(params[:id])
    @realty_photo = RealtyPhoto.new(params[:realty_photo])
    
    if !@realty_photo.photo_file_name.nil?
      @realty.realty_photos << @realty_photo
      @realty.save!
    end
    
    
    flash[:is_step] = params[:is_step]
  end
  
  def contacts
    @realty = Realty.find(params[:id])
  end
  
  def update_contacts
    @realty =Realty.find(params[:id])
    @realty.contacts.delete_all
    
    for p in params[:contact]
      if p[1]
        @realty.contacts << Contact.find(p[0])
      end
    end
    
    @realty.save! 
    
    respond_to do |format|
      format.html { redirect_to @realty}
    end
  end

  # GET /realties/1/edit
  def edit
    @realty = Realty.find(params[:id])
  end

  def note
    @realty = Realty.find(params[:id])
    session[:cart] = @realty.id

    render :text => @realty.id
  end

  # POST /realties
  # POST /realties.xml
  def create
      @realty = Realty.new(params[:realty])
      @realty.district_id = params[:district]
      @realty.user = current_user
      @realty.realty_field_values = get_realty_fields
      
      respond_to do |format|
        if @realty.save
          flash[:notice] = 'Realty was successfully created.'
          format.html { redirect_to photos_realty_path(@realty) + "?is_step=1" }
          format.xml  { render :xml => @realty, :status => :created, :location => @realty }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @realty.errors, :status => :unprocessable_entity }
        end
      end
  end

  # PUT /realties/1
  # PUT /realties/1.xml
  def update
    @realty = Realty.find(params[:id])
    @realty.realty_field_values.delete_all
    @realty.realty_field_values.push(get_realty_fields)
    
    respond_to do |format|
      if @realty.update_attributes(params[:realty])
        flash[:notice] = 'Объект успешно обновлен.'
        format.html { redirect_to(@realty) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @realty.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /realties/1
  # DELETE /realties/1.xml
  def destroy
    @realty = Realty.find(params[:id])
    @realty.destroy

    respond_to do |format|
      format.html { redirect_to(realties_url) }
      format.xml  { head :ok }
    end
  end
  
  def delete_photo
    @realty_photo = RealtyPhoto.find(params[:pid])
    @realty = @realty_photo.realty
    @realty_photo.destroy
    
    respond_to do |format|
      format.html { redirect_to photos_realty_path(@realty) }
    end
  end
  
  def create_user_request
    request = UserRequest.new(params[:search])
    request.user_id = current_user.id
    request.save!
    
    respond_to do |format|
      format.js { render :partial => "create_user_request", :locals => { :created => true} }
    end
  end
  
private
  def check_access
    if authorized?
      realty = Realty.find(params[:id])
      if !realty.nil? && realty.user_can_edit?(current_user)
        return true
      elsif
        flash[:notice] = 'Доступ запрещен.'
      end
    end
    
    access_denied
  end
  
  def get_realty_fields
      realty_fields = [];

      return realty_fields if params["f"].blank?
      
      for p in params["f"]
          realty_fields << RealtyFieldValue.new(:realty_field_id => p[0], :value => p[1]) unless p[1].blank?
      end  
      
      realty_fields
    end
 # end
end
