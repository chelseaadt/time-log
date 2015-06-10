class RegistrationsController < Devise::RegistrationsController

  def update

    @user = User.find(current_user.id)

    successfully_updated = if needs_password?(@user, params)
      @user.update_attributes(account_update_params)
      else
        params[:user].delete(:current_password)
        @user.update_attributes(account_update_params)
      end

      if successfully_updated
        set_flash_message :notice, :updated
        
        redirect_to after_update_path_for(@user)
      else
        render "edit"
      end

  end  
 
 def edit
 @cu = CompanyUser.where(:user_id => current_user.id).first
 end
  def new
    build_resource({})
    self.resource.companies.build
    respond_with self.resource
  end

  def create

    build_resource(sign_up_params)
 
    if(resource.save)

      company = resource.check_if_company_exists(params[:user][:companies])
      access_level = resource.check_what_access_level(company.company_users)

      company_user = resource.company_users.build(company_id: company.id, access_level: access_level, first_name: resource.first_name, last_name: resource.last_name)

      company_user.save
    end


    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
 
  private
 
  def sign_up_params
    allow = [:email, :password, :password_confirmation, :first_name, :last_name, :date_of_birth, :access_level, companies_attributes: [:domain, :name]]
    params.require(resource_name).permit(allow)
  end

  def needs_password?(user, params)
    user.email != params[:user][:email] ||
      params[:user][:password].present?
  end
 
end