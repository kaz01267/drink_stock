require "test_helper"

class NotificationMailerTest < ActionMailer::TestCase
  test "drinking_reminder" do
    user = User.create!(
      email: "mail_test@example.com",
      password: "password"
    )

    mail = NotificationMailer.drinking_reminder(user)

    assert_equal "【DrinkStock】飲酒記録をつけませんか？", mail.subject
    assert_equal [ "mail_test@example.com" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "最近の飲酒記録をつけませんか？", mail.text_part.body.decoded
  end

  test "recommended_drink" do
    user = User.create!(
      email: "recommended_test@example.com",
      password: "password"
    )

    drink = Drink.create!(
      user: user,
      name: "ラフロイグ",
      stock_ml: 700
    )

    mail = NotificationMailer.recommended_drink(user, drink)

    assert_equal "【DrinkStock】今日のおすすめのお酒", mail.subject
    assert_equal [ "recommended_test@example.com" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "ラフロイグ", mail.text_part.body.decoded
  end
end
