class Project < ApplicationRecord

  # ユーザーが複数のシフト申請を持つ関係を構築
  has_many :shift_requests, dependent: :destroy
  has_many :shift_assignments, dependent: :destroy
  has_many :users, through: :shift_assignments

  # work_dateを必須にする
  validates :work_date, presence: true

  # 指定期間内のProjectを取得
  scope :within, ->(start_date, end_date) { where(work_date: start_date..end_date) }

  # 必要人数に達するまで希望者を確定者に変換する例
  def complete_shift_assignments!
    needed = required_number - shift_assignments.count
    return if needed <= 0

    # 希望提出順に limit だけループして確定を作成
    shift_requests.limit(needed).each do |req|
      shift_assignments.create!(user: req.user)
    end

    # （任意）既に割り当て済みの shift_requests は削除しておく
    shift_requests.where(user_id: shift_assignments.pluck(:user_id)).destroy_all
  end

  # 与えられたユーザーIDに合わせてシフト割当を再構築する
  def update_assignments(user_ids)
    user_ids = Array(user_ids).map(&:to_i).uniq

    shift_assignments.where.not(user_id: user_ids).destroy_all

    existing_ids = shift_assignments.pluck(:user_id)
    (user_ids - existing_ids).each do |uid|
      shift_assignments.create!(user_id: uid)
    end
  end

end
