module ApplicationHelper
  # m月d日（日）
  def japanese_date_with_weekday(date)
    wdays = %w(日 月 火 水 木 金 土)
    "#{date.month}月#{date.day}日（#{wdays[date.wday]}）"
  end

  # m/dd（日）
  def japanese_short_date_with_weekday(date)
    wdays = %w(日 月 火 水 木 金 土)
    date.strftime("%-m/%d（#{wdays[date.wday]}）")
  end

end
