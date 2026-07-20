# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/drinking_reminder
  def drinking_reminder
    NotificationMailer.drinking_reminder
  end

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/recommended_drink
  def recommended_drink
    NotificationMailer.recommended_drink
  end
end
