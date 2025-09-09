class Manager::AssignmentsController < Manager::BaseController
  before_action :set_period, only: :index

  # ────────────────────────────────────
  # 割り当て一覧画面
  # GET /manager/assignments
  # ────────────────────────────────────
  def index
    @projects   = Project.within(@start_date, @end_date)
    @users      = User.order(:name).pluck(:name, :id)
    @max_slots  = @projects.map(&:required_number).max || 0
  end

  # ────────────────────────────────────
  # メンバー割り当て更新
  # PATCH /manager/assignments/update_members
  # ────────────────────────────────────
  def update_members
    Project.transaction do
      assignments_params.each do |project_id, user_ids|
        Project.find(project_id).update_assignments(user_ids)
      end
    end

    redirect_to manager_assignments_path, notice: "配置メンバーを更新しました"
  end

  private

  def set_period
    period      = params[:period] || Time.zone.today.strftime("%Y%m")
    @start_date = Date.strptime(period, "%Y%m").beginning_of_month
    @end_date   = @start_date.end_of_month
    @prev_period = (@start_date - 1.month).strftime("%Y%m")
    @next_period = (@start_date + 1.month).strftime("%Y%m")
  end

  # 内部は { "project_id" => [user_id, ...], ... } のハッシュ
  def assignments_params
    params.require(:assignments).to_h
  end
end
