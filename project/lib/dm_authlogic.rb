module DMAuthlogic
  def self.included(klass)
    klass.send(:instance_eval) do
      attr_accessor :password_confirmation

      class << self
        alias validates_length_of         validates_length
        alias validates_uniqueness_of     validates_is_unique
        alias validates_confirmation_of   validates_is_confirmed
        alias validates_presence_of       validates_present
        alias validates_format_of         validates_format
        alias validates_numericality_of   validates_is_number
      end

      property :id, DataMapper::Types::Serial
      property :full_name, String, :length => 1000

      property :email_address, String, :index => true, :null => false, :length => 1000
      property :crypted_password, String, :length => 255, :null => false
      property :password_salt, String, :length => 255, :null => false
      property :persistence_token, String, :length => 255, :index => true, :null => false
      property :login_count, Integer, :default => 0, :null => false
      property :last_request_at, DateTime
      property :last_login_at, DateTime, :index => true
      property :current_login_at, DateTime
      property :last_login_ip, String
      property :current_login_ip, String

      timestamps :at

      include Authlogic::ActsAsAuthentic::Base
      include Authlogic::ActsAsAuthentic::Email
      include Authlogic::ActsAsAuthentic::LoggedInStatus
      include Authlogic::ActsAsAuthentic::Login
      include Authlogic::ActsAsAuthentic::MagicColumns
      include Authlogic::ActsAsAuthentic::Password
      include Authlogic::ActsAsAuthentic::PerishableToken
      include Authlogic::ActsAsAuthentic::PersistenceToken
      include Authlogic::ActsAsAuthentic::RestfulAuthentication
      include Authlogic::ActsAsAuthentic::SessionMaintenance
      include Authlogic::ActsAsAuthentic::SingleAccessToken
      include Authlogic::ActsAsAuthentic::ValidationsScope

      class << self 

        def < klass
          return true if klass == ::ActiveRecord::Base
          super(klass)
        end


        def column_names
          properties.map {|property| property.name.to_s }
        end

        def named_scope name, options={}, &block
          block = options if options.is_a? Proc
          if block
            meta_def name do
              all(block.call)
            end
          else
            meta_def name do
              all(options)
            end
          end
        end

        def define_callbacks *callbacks
          callbacks.each do |method_name|
            callback = method_name.scan /^(before|after)/

            method = %{
              def #{method_name} method_sym, options={}, &block
                if block_given?
                  #{callback} :#{method_name}, method_sym, &block
                else
                  #{callback} :#{method_name} do
                    if options[:if]     
                      return false unless send(options[:if])
                    end

                    if options[:unless] 
                      return false if send(options[:unless])
                    end

                    send method_sym
                  end
                end
              end
            }        

            instance_eval method

            define_method method_name do; end
          end
        end
      end

      self.define_callbacks *%w(
        before_validation
        before_save
        after_save
      )

      def self.find_with_case(field, value, sensitivity = true)
        first :email => value.downcase
      end

      def self.quoted_table_name
        "users"
      end

      def self.default_timezone
        :utc
      end

      def self.primary_key
        :id
      end

      alias_method :changed?, :dirty?
      class << self
        alias find_by_id get
      end

      def method_missing method_name, *args, &block
        name = method_name.to_s
        super unless name[/_changed\?$/]
        dirty_attributes.include? name.scan(/(.*)_changed\?$/)
      end

      acts_as_authentic do |config| config.instance_eval do
        validates_uniqueness_of_email_field_options :scope => :id
      end end

      def profile_image_url
        gravatar_url
      end

      def display_name
        @display_name ||= "#{full_name} (#{email})"
      end      
    end
  end
end

module DMAuthlogicSession
private
  def search_for_record(*args)
    klass.send(*args)
  end

  def save_record(alternate_record = nil)
    r = alternate_record || record
    r.save_without_session_maintenance if r && r.changed?
  end
end