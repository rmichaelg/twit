module Searchable
  extend ActiveSupport::Concern

  included do
    # todo: make all of this async
    after_save :create_or_update_swiftype_document, if: :should_index
    after_destroy :delete_swiftype_document, if: :should_index

    # these methods can be overridden in the model
    def absolute_url
      Rails.application.routes.url_helpers.send("#{self.class.name.downcase}_url", self,
                                                    host: Rails.configuration.action_mailer.default_url_options[:host])
    end

    def swiftype_fields
      [{name: 'name', value: name, type: 'string'},
       {name: 'url', value: absolute_url, type: 'enum'},
       {name: 'created_at', value: created_at.iso8601, type: 'date'}]
    end

    def should_index
      true
    end

    protected

    def create_or_update_swiftype_document
      client = Swiftype::Easy.new
      client.create_or_update_document(ENV['SWIFTYPE_ENGINE_SLUG'],
                                       self.class.name.downcase.pluralize,
                                       { external_id: id,
                                         fields: swiftype_fields })
    end

    def delete_swiftype_document
      client = Swiftype::Easy.new
      begin
        client.destroy_document(ENV['SWIFTYPE_ENGINE_SLUG'], self.class.name.downcase.pluralize, id)
      rescue
        #don't cause a 500 error if the document's missing from the index (encountered in dev)
      end
    end
  end
end
