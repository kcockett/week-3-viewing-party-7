class UsersController <ApplicationController 
  def new 
    @user = User.new()
  end 

  def show 
    if current_user
      @user = User.find(params[:id])
    else
      redirect_to login_path
    end
  end 

  def create 
    user = User.create(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to user_path(user)
    else  
      flash[:error] = user.errors.full_messages.to_sentence
      redirect_to register_path
    end 
  end 

  def login_form

  end

  def login_user
    if !login_params[:email] || !login_params[:password] || !User.exists?(email: login_params[:email])
      flash[:error] = "Sorry, your credentials are bad."
      render :login_form
    else
      user = User.find_by(email: login_params[:email])
      if user.authenticate(login_params[:password])
        session[:user_id] = user.id
        flash[:success] = "Welcome, #{user.email}!"
        redirect_to user_path(user)
      else
        flash[:error] = "Sorry, your credentials are bad."
        render :login_form
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path
  end

  private 

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end 

  def login_params
    params.permit(:email, :password)
  end
end 