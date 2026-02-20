# lib/tasks/i18n_missing.rake
namespace :i18n do
    desc "Detect missing I18n keys in views/controllers (simple grep based)"
    task :missing do
      files = Dir["app/**/*.rb", "app/**/*.erb"]
      keys = []

      files.each do |path|
        content = File.read(path)
        content.scan(/t\(\s*["']([^"']+)["']/).each { |m| keys << m[0] }
        content.scan(/I18n\.t\(\s*["']([^"']+)["']/).each { |m| keys << m[0] }
      end

      keys.uniq.sort.each do |key|
        # pluralization/counter-required keys should be skipped
        next if key == "errors.messages.not_saved"

        v = I18n.t(key, default: nil)
        puts key if v.nil? || (v.is_a?(String) && v.start_with?("translation missing:"))
      end
    end
  end
