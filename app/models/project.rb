class Project < ApplicationRecord

  # ユーザーが複数のシフト申請を持つ関係を構築
  has_many :shift_requests, dependent: :destroy
  has_many :shift_assignments, dependent: :destroy
  has_many :users, through: :shift_assignments

  # work_dateを必須にする
  validates :work_date, presence: true

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

end
