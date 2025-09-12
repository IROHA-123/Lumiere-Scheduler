class User < ApplicationRecord
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  def admin?
    role == 'admin'
  end

  has_many :shift_requests
  has_many :shift_assignments
end
