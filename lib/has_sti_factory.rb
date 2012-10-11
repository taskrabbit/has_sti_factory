require 'has_sti_factory/version'
require 'has_sti_factory/railtie' if defined?(Rails)

module HasStiFactory

  autoload :Base,     'has_sti_factory/base'
  autoload :HasTypes, 'has_sti_factory/has_types'

end