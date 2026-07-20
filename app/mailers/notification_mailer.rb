class NotificationMailer < ApplicationMailer
  def drinking_reminder(user)
    @user = user

    mail(
      to: @user.email,
      subject: "【DrinkStock】飲酒記録をつけませんか？"
    )
  end

  def recommended_drink(user, drink)
    @user = user
    @drink = drink

    mail(
      to: @user.email,
      subject: "【DrinkStock】今日のおすすめのお酒"
    )
  end
end
