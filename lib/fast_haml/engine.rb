require 'temple'
require 'fast_haml/compiler'
require 'fast_haml/html'
require 'fast_haml/parser'

module FastHaml
  class Engine < Temple::Engine
    define_options(
      generator: Temple::Generators::ArrayBuffer,
    )

    def initialize(opts = {})
      super(opts.merge(
        format: :html,
        attr_quote: "'",
      ))
    end

    use Parser
    use Compiler
    use Html
    filter :Escapable
    filter :ControlFlow
    filter :MultiFlattener
    filter :StaticMerger
    use :Generator do
      options[:generator].new(options.to_hash.reject {|k,v| !options[:generator].options.valid_key?(k) })
    end
  end
end
