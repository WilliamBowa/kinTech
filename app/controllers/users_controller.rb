class UsersController < ApplicationController
  before_action :logged_in_user, only: [ :index, :edit, :update, :show ]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [ :destroy, :index ]

  def index
     @user = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email

      # UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."
      redirect_to login_path
      # log_in @user
      #handle a succesful save
      # flash.now[:success]= "Welcome to CreditApp!"
      # redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      #handle a succesful update
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    User.find(params[:id]).destroy
    flash[:success] = "#{@user.firstname} is deleted"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:firstname, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end
  end

  #confirm the correct user
  def correct_user
    @user = User.find(params[:id])
    redirect_to login_url unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to login_url unless current_user.admin?
  end
end
