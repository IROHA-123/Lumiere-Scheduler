# app/controllers/scheduler/shift_requests_controller.rb
class Scheduler::ShiftRequestsController < ApplicationController
  layout 'scheduler'
  before_action :authenticate_user!

  def index
    today = Date.current

    # -- カレンダー描画用データ ----------------------------------------
    @month_calendars = (0..2).map do |i|
      base_date = today >> i
      first_day = base_date.beginning_of_month
      last_day  = base_date.end_of_month

      start_date = first_day.beginning_of_week(:monday)
      end_date   = last_day.end_of_week(:monday)

      days = (start_date..end_date).to_a
      { base_date: base_date, days: days }
    end

    all_days = @month_calendars.flat_map { |h| h[:days] }
    @projects_by_date = Project
      .where(work_date: all_days)
      .includes(:shift_assignments)
      .group_by(&:work_date)

    # -- マイシフト（確定済み・提出済み）一覧用データ --------------------

    # 1) 今日以降の確定済みシフトを取得＆並び替え
    confirmed = current_user.shift_assignments
      .joins(:project)
      .where('projects.work_date >= ?', today)
      .includes(:project)
      .order('projects.work_date ASC, projects.start_time ASC')
    @shift_assignments_list = confirmed

    # 2) 確定済みの project_id リストを作成
    assigned_ids = confirmed.pluck(:project_id)

    # 3) 今日以降の提出済みシフトから「確定済み」を除外
    @shift_requests_list = current_user.shift_requests
      .joins(:project)
      .where('projects.work_date >= ?', today)
      .where.not(project_id: assigned_ids)
      .includes(:project)
      .order('projects.work_date ASC, projects.start_time ASC')
  end

  # -- モーダル表示用アクション----------------------------------------
  def modal
    ids      = params[:project_ids].to_s.split(',').map(&:to_i)
    projects = Project.where(id: ids)
    render partial: "scheduler/shift_requests/modal_body", locals: { projects: projects }
  end

  # -- シフト希望送信-------------------------------------------------
  def create
    shift_request_params = params.require(:shift_request).permit(:project_id, :status)
    shift_request = current_user.shift_requests.find_or_initialize_by(shift_request_params)

    if shift_request.save
      redirect_to scheduler_shift_requests_path, notice: "希望を送信しました"
    else
      redirect_to scheduler_shift_requests_path, alert: "エラーが発生しました"
    end
  end
end
