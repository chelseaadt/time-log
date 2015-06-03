class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if current_user.present?
      @users = User.where(:id => current_user.id)
        @cu = CompanyUser.where(:user_id => current_user.id).first
    else
      @users = User.all
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if current_user.present?
        @cu = CompanyUser.where(:user_id => current_user.id).first
     end
  end

  # GET /users/new
  def new
    @user = User.new
    @user.companies.build

    @cu = CompanyUser.where(:user_id => current_user.id).first
  end

  # GET /users/1/edit
  def edit
    @cu = CompanyUser.where(:user_id => current_user.id).first
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :date_of_birth, :access_level, :domain)
    end
end
