class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # admin かどうか、true or false　を返す
  def admin?
    role == 'admin'
  end

  has_many :shift_requests
  has_many :shift_assignments

end
