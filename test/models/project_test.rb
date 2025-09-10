require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "within returns projects in range" do
    p1 = projects(:one)
    p2 = projects(:two)
    p3 = Project.create!(title: "Outside", work_date: Date.new(2025, 6, 1))

    results = Project.within(Date.new(2025, 5, 1), Date.new(2025, 5, 31))
    assert_includes results, p1
    assert_includes results, p2
    assert_not_includes results, p3
  end

  test "update_assignments rebuilds assignments based on user_ids" do
    project = projects(:one)
    user1 = users(:one)
    user2 = users(:two)

    assert_equal [user1.id], project.shift_assignments.pluck(:user_id)

    project.update_assignments([user2.id])

    assert_equal [user2.id], project.shift_assignments.pluck(:user_id)
  end
end
