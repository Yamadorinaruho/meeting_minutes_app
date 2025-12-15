# データベースをクリア
puts "Cleaning database..."
MeetingMinuteShare.destroy_all
MeetingMinute.destroy_all
User.destroy_all
Employee.destroy_all
Position.destroy_all
Department.destroy_all
Company.destroy_all

# 会社
puts "Creating company..."
company = Company.create!(name: "株式会社サンプル")

# 部署
puts "Creating departments..."
departments = {
  dev: Department.create!(company: company, name: "開発部"),
  sales: Department.create!(company: company, name: "営業部"),
  hr: Department.create!(company: company, name: "人事部"),
  marketing: Department.create!(company: company, name: "マーケティング部"),
  finance: Department.create!(company: company, name: "経理部")
}

# 役職（時給付き）
puts "Creating positions..."
positions = {
  director: Position.create!(company: company, name: "部長", hourly_rate: 8000, rank: 1),
  manager: Position.create!(company: company, name: "課長", hourly_rate: 5500, rank: 2),
  chief: Position.create!(company: company, name: "係長", hourly_rate: 4000, rank: 3),
  senior: Position.create!(company: company, name: "主任", hourly_rate: 3200, rank: 4),
  staff: Position.create!(company: company, name: "一般", hourly_rate: 2500, rank: 5)
}

# 従業員データ
puts "Creating employees..."
employees_data = [
  { num: "E001", name: "山田 太郎", email: "yamada@example.com", dept: :dev, pos: :director, admin: true },
  { num: "E002", name: "田中 花子", email: "tanaka@example.com", dept: :sales, pos: :manager, admin: false },
  { num: "E003", name: "鈴木 一郎", email: "suzuki@example.com", dept: :hr, pos: :manager, admin: false },
  { num: "E004", name: "佐藤 美咲", email: "sato@example.com", dept: :dev, pos: :chief, admin: false },
  { num: "E005", name: "高橋 健太", email: "takahashi@example.com", dept: :dev, pos: :senior, admin: false },
  { num: "E006", name: "伊藤 愛", email: "ito@example.com", dept: :sales, pos: :chief, admin: false },
  { num: "E007", name: "渡辺 翔", email: "watanabe@example.com", dept: :sales, pos: :staff, admin: false },
  { num: "E008", name: "中村 由美", email: "nakamura@example.com", dept: :marketing, pos: :manager, admin: false },
  { num: "E009", name: "小林 大輔", email: "kobayashi@example.com", dept: :marketing, pos: :staff, admin: false },
  { num: "E010", name: "加藤 さくら", email: "kato@example.com", dept: :hr, pos: :staff, admin: false },
  { num: "E011", name: "吉田 拓海", email: "yoshida@example.com", dept: :finance, pos: :chief, admin: false },
  { num: "E012", name: "山本 真央", email: "yamamoto@example.com", dept: :finance, pos: :staff, admin: false },
  { num: "E013", name: "松本 陽子", email: "matsumoto@example.com", dept: :dev, pos: :staff, admin: false },
  { num: "E014", name: "井上 裕太", email: "inoue@example.com", dept: :marketing, pos: :staff, admin: false },
  { num: "E015", name: "木村 結衣", email: "kimura@example.com", dept: :sales, pos: :staff, admin: false }
]

employees = {}
employees_data.each do |data|
  emp = Employee.create!(
    company: company,
    department: departments[data[:dept]],
    position: positions[data[:pos]],
    employee_number: data[:num],
    name: data[:name],
    email: data[:email],
    status: :active,
    admin: data[:admin]
  )
  employees[data[:email].split("@").first] = emp

  User.create!(
    company: company,
    employee: emp,
    email: data[:email],
    password: "password123"
  )
end

# 議事録
puts "Creating meeting minutes..."

# 1週間前の会議
m1 = MeetingMinute.create!(
  company: company,
  employee: employees["yamada"],
  title: "週次開発定例",
  start_time: 7.days.ago.change(hour: 10, min: 0),
  end_time: 7.days.ago.change(hour: 11, min: 0),
  content: "## 議題\n- スプリント振り返り\n- 次週タスク確認\n\n## 決定事項\n- リリース日を来週金曜に設定"
)
MeetingMinuteShare.create!(meeting_minute: m1, employee: employees["sato"])
MeetingMinuteShare.create!(meeting_minute: m1, employee: employees["takahashi"])
MeetingMinuteShare.create!(meeting_minute: m1, employee: employees["matsumoto"])

# 5日前の会議
m2 = MeetingMinute.create!(
  company: company,
  employee: employees["tanaka"],
  title: "営業戦略会議",
  start_time: 5.days.ago.change(hour: 14, min: 0),
  end_time: 5.days.ago.change(hour: 16, min: 30),
  content: "## 議題\n- Q4売上目標\n- 新規顧客開拓\n\n## 決定事項\n- 展示会出展を決定"
)
MeetingMinuteShare.create!(meeting_minute: m2, employee: employees["ito"])
MeetingMinuteShare.create!(meeting_minute: m2, employee: employees["watanabe"])
MeetingMinuteShare.create!(meeting_minute: m2, employee: employees["kimura"])

# 4日前の会議
m3 = MeetingMinute.create!(
  company: company,
  employee: employees["nakamura"],
  title: "マーケティング施策検討",
  start_time: 4.days.ago.change(hour: 10, min: 0),
  end_time: 4.days.ago.change(hour: 12, min: 0),
  content: "## 議題\n- SNS運用方針\n- 広告予算配分\n\n## 決定事項\n- Instagram強化"
)
MeetingMinuteShare.create!(meeting_minute: m3, employee: employees["kobayashi"])
MeetingMinuteShare.create!(meeting_minute: m3, employee: employees["inoue"])

# 3日前の会議
m4 = MeetingMinute.create!(
  company: company,
  employee: employees["suzuki"],
  title: "採用面接振り返り",
  start_time: 3.days.ago.change(hour: 15, min: 0),
  end_time: 3.days.ago.change(hour: 16, min: 0),
  content: "## 議題\n- 候補者評価\n- 次回選考\n\n## 決定事項\n- 2名を最終面接へ"
)
MeetingMinuteShare.create!(meeting_minute: m4, employee: employees["kato"])

# 2日前の会議
m5 = MeetingMinute.create!(
  company: company,
  employee: employees["yoshida"],
  title: "月次経理報告",
  start_time: 2.days.ago.change(hour: 9, min: 0),
  end_time: 2.days.ago.change(hour: 10, min: 30),
  content: "## 議題\n- 月次決算\n- 予算執行状況\n\n## 決定事項\n- 経費削減検討"
)
MeetingMinuteShare.create!(meeting_minute: m5, employee: employees["yamamoto"])

# 1日前の会議
m6 = MeetingMinute.create!(
  company: company,
  employee: employees["yamada"],
  title: "新機能企画会議",
  start_time: 1.day.ago.change(hour: 13, min: 0),
  end_time: 1.day.ago.change(hour: 14, min: 30),
  content: "## 議題\n- 新機能要件定義\n- スケジュール\n\n## 決定事項\n- 来月開発着手"
)
MeetingMinuteShare.create!(meeting_minute: m6, employee: employees["sato"])
MeetingMinuteShare.create!(meeting_minute: m6, employee: employees["tanaka"])

# 本日の会議
m7 = MeetingMinute.create!(
  company: company,
  employee: employees["yamada"],
  title: "全体朝会",
  start_time: Time.current.change(hour: 9, min: 0),
  end_time: Time.current.change(hour: 9, min: 30),
  content: "## 連絡事項\n- 今週の予定共有\n- 各部署報告"
)
MeetingMinuteShare.create!(meeting_minute: m7, employee: employees["tanaka"])
MeetingMinuteShare.create!(meeting_minute: m7, employee: employees["suzuki"])
MeetingMinuteShare.create!(meeting_minute: m7, employee: employees["nakamura"])
MeetingMinuteShare.create!(meeting_minute: m7, employee: employees["yoshida"])

puts ""
puts "=" * 50
puts "Seed completed!"
puts "=" * 50
puts ""
puts "Companies: #{Company.count}"
puts "Departments: #{Department.count}"
puts "Positions: #{Position.count}"
puts "Employees: #{Employee.count}"
puts "Meeting Minutes: #{MeetingMinute.count}"
puts ""
puts "-" * 50
puts "Login credentials (password: password123)"
puts "-" * 50
employees_data.each do |data|
  badge = data[:admin] ? " [ADMIN]" : ""
  puts "  #{data[:email]}#{badge}"
end
puts ""
