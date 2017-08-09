module Authoreyes
  # Authoreyes sets up a Railtie to create its authorization engine
  # as a constant during the rails initialization.  Middleware is also
  # configured here.
  class Railtie < Rails::Railtie
    # Error for bad configuration
    class InvalidConfigurationOption < StandardError; end

    # Allow users to configure Authoreyes in an initializer file
    # +auth_rules_file+ is the path of the authorization rules file.
    config.authoreyes = ActiveSupport::OrderedOptions.new

    initializer 'authoreyes.setup', before: 'authoreyes.engine' do |_app|
      # Set default Authoreyes options
      default_options = ActiveSupport::OrderedOptions.new
      default_options.auth_rules_file =
        File.path("#{Rails.root}/config/authorization_rules.rb")
      default_options.mode = :whitelist

      # Validates options
      unless [nil, :whitelist, :blacklist].include? config.authoreyes.mode
        raise InvalidConfigurationOption,
              'Unrecognized mode.  Valid options are :whitelist and :blacklist'
      end

      # Merge user options with defaults
      config.authoreyes = default_options.merge(config.authoreyes)
    end

    # Controller integration
    initializer 'authoreyes.in_controller' do |_app|
      # Adds render_unauthorized to API ActionController::Base for support
      # of development tools such as Graphiql
      # TODO: Perhaps handle this more gracefully
      if Rails.application.config.api_only
        ActionController::Base.send(:define_method, :render_unauthorized) do
          raise Authoreyes::Authorization::NotAuthorized
        end
      end

      # Set before actions
      ActiveSupport.on_load :action_controller do
        if Rails.application.config.api_only
          before_action :render_unauthorized
        else
          before_action :redirect_if_unauthorized
          after_action :set_unauthorized_status_code
        end
      end
    end

    # Set up the Authoreyes ENGINE
    initializer 'authoreyes.engine' do |app|
      config.before_initialize do
        # Set up parser and parse rules
        parser = Authoreyes::Parser::DSLParser.new
        parser.load! app.config.authoreyes.auth_rules_file

        # Create new engine using parsed rules an make constant
        engine = Authoreyes::Authorization::Engine.new reader: parser
        Authoreyes::ENGINE = engine
      end
    end
  end
end
