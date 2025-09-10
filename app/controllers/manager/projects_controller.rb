class Manager::ProjectsController < Manager::BaseController
  # ────────────────────────────────────
  # GET /manager/projects
  # 案件一覧
  def index
    @projects = Project.order(work_date: :asc)
  end

  # ────────────────────────────────────
  # GET /manager/projects/new
  # 新規案件登録フォーム
  def new
    @project = Project.new
  end

  # ────────────────────────────────────
  # POST /manager/projects
  # 新規案件登録処理
  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to manager_projects_path, notice: "案件を登録しました"
    else
      render :new
    end
  end

  # ────────────────────────────────────
  # GET /manager/projects/:id/assignment
  # 個別割当編集画面
  def assignment
    @project        = Project.find(params[:id])
    # 確定済みの ShiftAssignment レコード
    @assigned_users = @project.shift_assignments.includes(:user)
    # 確定済みユーザーを除外した ShiftRequest レコード
    assigned_ids    = @assigned_users.map(&:user_id)
    @shift_requests = @project.shift_requests
                              .includes(:user)
                              .where.not(user_id: assigned_ids)
  end

  # ────────────────────────────────────
  # PATCH /manager/projects/:id/complete_assignment
  # 指定ユーザーを確定する
  def complete_assignment
    @project = Project.find(params[:id])
    user_id  = params.require(:user_id).to_i

    # 既存の希望・確定レコードを削除してから確定を作成
    @project.shift_requests.where(user_id: user_id).destroy_all
    @project.shift_assignments.where(user_id: user_id).destroy_all
    @project.shift_assignments.create!(user_id: user_id)

    redirect_to assignment_manager_project_path(@project), notice: "スタッフを確定しました"
  end

  # ────────────────────────────────────
  # PATCH /manager/projects/:id/toggle_request
  # 確定⇔希望 を切り替える Ajax/HTML ハンドラ
  def toggle_request
    @project = Project.find(params[:id])
    user_id  = params.require(:user_id).to_i

    # まずどちらのテーブルにもレコードがない状態にリセット
    @project.shift_assignments.where(user_id: user_id).destroy_all
    @project.shift_requests   .where(user_id: user_id).destroy_all

    # 今現在確定済みなら、希望に戻す
      if params[:from] == "assignment"
        @project.shift_requests.create!(user_id: user_id)
      else
        @project.shift_assignments.create!(user_id: user_id)
      end

    render json: {
      assigned:  @project.shift_assignments.pluck(:user_id),
      requested: @project.shift_requests.pluck(:user_id)
    }
  end

  private

  # Strong Parameters
  def project_params
    params.require(:project)
          .permit(:title, :work_date, :start_time, :end_time, :location, :required_number)
  end
end
