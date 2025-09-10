class ApplicationController < ActionController::Base
  # Devise でサインイン直後のリダイレクト先を切り替える
  def after_sign_in_path_for(resource)
    if resource.admin?
      manager_assignments_path    # 管理者は管理者画面 へ
    else
      super               # それ以外はスタッフ画面(default)へ
    end
  end
end
