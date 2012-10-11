module HasStiFactory::Base
  extend ActiveSupport::Concern

  module ClassMethods
    def has_sti_factory(default_class=nil)
      # set the model name to always be the parent to use parent controller
      @default_class = default_class
      
      extend HasStiFactory::Base::StiClassMethods
      class << self
        alias_method_chain :new, :factory unless method_defined?(:new_without_factory)
      end
    end
  end
  
  module StiClassMethods
    def model_name
      @my_model_name ||= ::ActiveModel::Name.new(root_class)
    end
    def decl_auth_context
      model_name.to_s.tableize.to_sym
    end
    
    def root_class
      top = nil
      up = self
      until up.nil? or up.name.downcase.include?("activerecord")
        top = up
        up = top.superclass
      end
      top || self
    end

    def root_name
      root_class.name
    end
    
    def subclass_names
      subclasses.map(&:name).push(self.name)
    end
    
    def sti_default
      return self if @default_class.nil? or self.name != root_name
      check = @default_class
      check = @default_class.to_s.classify.constantize unless check.is_a? Class
      check
    end
    
    def new_subclass(name)
      params = {}
      params[self.inheritance_column.to_sym] = name.classify unless name.blank?
      out = self.new_with_factory(params)
      out = sti_default.new if out.class.name == root_name
      out
    end

    def new_with_factory(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      
      klass_name = options.delete(self.inheritance_column.to_sym) || self
      klass = self.subclass_names.include?(klass_name) ? klass_name.constantize : self
      
      klass.new_without_factory(options)
    end
    
  end
end