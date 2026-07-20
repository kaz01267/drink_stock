namespace :notification_mailer do
    desc "飲酒記録リマインドメールを送信"
    task send_drinking_reminders: :environment do
      User.where(drinking_reminder_email_enabled: true).find_each do |user|
        puts "Send drinking reminder to #{user.email}"
        NotificationMailer.drinking_reminder(user).deliver_now
      end
    end

    desc "おすすめのお酒メールを送信"
    task send_recommended_drinks: :environment do
      User.where(recommended_drink_email_enabled: true).find_each do |user|
        drink = user.drinks.where("stock_ml > 0").order("RANDOM()").first

        if drink.blank?
          puts "Skip #{user.email}: 在庫があるお酒がありません"
          next
        end

        puts "Send recommended drink to #{user.email}: #{drink.name}"
        NotificationMailer.recommended_drink(user, drink).deliver_now
      end
    end
  end
