class PhonifyGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :user, :type => :string, :default => "User"
  class_option :api_key, :default => "CHANGEME", :description => "Set your API key from phonify.io"
  class_option :app_name, :default => "app1", :description => "Name your phonify.io app"
  class_option :app_key, :default => "CHANGEME", :description => "Set your app key from phonify.io"

  def generate_phonify
    sanitized_app_name = options.app_name.gsub(/\W+/, '').underscore
    Dir[File.expand_path('db/migrate/*.rb', self.class.source_root)].sort.each_with_index do |file, index|
      copy_file file, 'db/migrate/' + migrate_number(file, index) + File.basename(file).gsub(/^\d+/, '')
    end
    inject_into_file "app/models/#{user.underscore}.rb", :after => "class #{user.camelize} < ActiveRecord::Base\n" do
      "  has_one :#{sanitized_app_name}_subscription, #{hash_string(:as => '"owner"', :class_name => '"Phonify::Subscription"', :conditions => '{ ' + hash_string(:app_id => "Phonify.config.#{sanitized_app_name}") + ' }')}\n"
    end
    initializer("phonify.rb") do
      <<-RUBY.strip_heredoc
      # app settings
      Phonify.config.#{sanitized_app_name} = '#{options.app_key}'
      # Phonify.config.name2 = 'key2'
      # Phonify.config.anyname = 'anykey'

      # API authentication
      Phonify.config.api_key = '#{options.api_key}'
      RUBY
    end
  end
  
  private

  def migrate_number(file, index)
    if existing = Dir["db/migrate/" + File.basename(file).gsub(/^\d+/, '*')].first
      File.basename(existing).scan(/^\d+/).first
    end || (Time.now.utc + index).strftime("%Y%m%d%H%M%S")
  end

  def hash_string(hash)
    hash.collect do |k,v|
      case RUBY_VERSION
      when /1\.9\b/
        "#{k}: #{v}"
      else
        ":#{k} => #{v}"
      end
    end.join(', ')
  end

end
