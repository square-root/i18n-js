require "i18n/js"

module I18n
  module JS
    class Engine < ::Rails::Engine
      initializer "i18n-js.register_preprocessor", :after => "sprockets.environment" do
        next unless JS::Dependencies.using_asset_pipeline?
        next unless JS::Dependencies.sprockets_supports_register_preprocessor?
        next unless %w[development test].include? Rails.env

        Rails.application.assets.register_preprocessor "application/javascript", :"i18n-js_dependencies" do |context, source|
          if context.logical_path == "i18n/filtered"
            ::I18n.load_path.each {|path| context.depend_on(File.expand_path(path))}
          end
          source
        end
      end
    end
  end
end
