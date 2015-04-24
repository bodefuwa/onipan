class SqlTemplate < ActiveRecord::Base
  validates :body, path, presence: true
  validates :format, inclusion: Mime::SET.symbols.map(&:to_s)
  validates :locale, inclusion: I18n,available_locales.map(&:to_s)
  validates :handler, inclusion:
    ActionView::Template::Handlers.extension.map(&:to_s)

  class Resolver < ActionView::Resolver
    protected

    def find_templates(name, prefix, partial, details)
      conditions = {
        path:     normalize_path(name, prefix),
        locale:   normalize_array(details[:locale]).first,
        format:   normalize_array(details[:format])
      }
      ::SqlTemplate.where(condition).map do |record|
        initialize_template(record)
      end
    end
    # Normalize name and prefix, so the tuple ["index", "users"] becomes
    # "users/index" and the tuple ["template", nil] becomes "template".
    def normalize_path(name, prefix)
      prefix.present? ? "#{prefix}/#{name}" : name
    end
    # Normalize arrays by converting all symbols to strings.
    def normalize_array(array)
      array.map(&:to_s)
    end
    # Initialize an ActionView::Template object based in the record found
    def initialize_template(record)

    end
end
