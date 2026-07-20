class AddNotificationSettingsToUsers < ActiveRecord::Migration[7.2]
  def change
    rename_column :users, :email_notification_enabled, :drinking_reminder_email_enabled
    add_column :users, :recommended_drink_email_enabled, :boolean, default: true, null: false
  end
end
