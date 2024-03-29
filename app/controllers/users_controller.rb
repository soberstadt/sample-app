class UsersController < ApplicationController
  before_filter :already_in, :only => [:new, :create]
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => :destroy
  
  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate(:page => params[:page])
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign Up"
      @user.password = "";
      @user.password_confirmation = "";
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile update"
      redirect_to @user
    else
      @title ="Edit user"
      render 'edit'
    end
  end
  
  def destroy
    user = User.find(params[:id])
    if current_user?(user)
      flash[:error] = "Cannot delete yourself."
    else
      user.destroy
      flash[:success] = "User destroyed."
    end
    redirect_to users_path
  end

  private
  
    def already_in
      redirect_to(root_path) unless !signed_in?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end