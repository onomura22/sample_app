class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    if params[:q] && params[:q].reject { |key, value| value.blank? }.present?
      @q = User.ransack(search_params, activated_true: true)
      @title = "検索結果"
    else
      @q = User.ransack(activated_true: true)
      @title = "ユーザー"
    end
    @users = @q.result.paginate(page: params[:page])
  end

  def show
    @youbi = %w[日 月 火 水 木 金 土]
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @date = Date.today
    @start_date =  Date.new(Date.today.year,Date.today.month, 1)
    @end_date = @start_date.end_of_month
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
    # @user.send_activation_email
    #   flash[:info] = "メールを確認して、アカウントを認証してください。"
    # redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを変更しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました。"
    redirect_to users_url
  end
  
  def following
    @title = "フォロー"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def search_params
      params.require(:q).permit(:name_cont)
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :department,:password,
                                   :password_confirmation)
    end

    # beforeフィルター

    # 正しいユーザーかどうかを確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうかを確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end