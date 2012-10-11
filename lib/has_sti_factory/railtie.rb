module HasStiFactory
  class Railtie < Rails::Railtie

    initializer 'has_sti_factory.hook' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :extend,    HasStiFactory::HasTypes
        ActiveRecord::Base.send :include,   HasStiFactory::Base
      end
    end

  end
end