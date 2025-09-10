class Manager::UsersController < Manager::BaseController
  before_action :set_user, only: [:edit, :update, :destroy]

  # GET /manager/users
  def index
    @users = User.all.order(:joined_on, :name)
  end

  # GET /manager/users/new
  def new
    @user = User.new
  end

  # POST /manager/users
  def create
    random_pw = generate_random_password
    @user = User.new(user_params.merge(
      password:              random_pw,
      password_confirmation: random_pw,
      skill_level: 0
    ))

    if @user.save
      # @user.send_reset_password_instructions
      redirect_to manager_users_path, notice: "ユーザーを登録しました"
    else
      render :new
    end
  end

  # GET /manager/users/:id/edit
  def edit
    # @user は set_user でセット済み
  end

  # PATCH/PUT /manager/users/:id
  def update
    if @user.update(user_params)
      redirect_to manager_users_path, notice: "ユーザー情報を編集しました"
    else
      render :edit
    end
  end

  # DELETE /manager/users/:id
  def destroy
    @user.destroy
    redirect_to manager_users_path, notice: "ユーザーを削除しました"
  end

  private

  def user_params
    params.require(:user).permit(
      :role,
      :email,
      :name,
      :employee_id,
      :joined_on,
      :work_style,
      :skill_level
    )
  end

  def set_user
    @user = User.find(params[:id])
  end

  def generate_random_password
    SecureRandom.hex(10)
  end
end
