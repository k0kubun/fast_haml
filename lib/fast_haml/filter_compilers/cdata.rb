require 'fast_haml/filter_compilers/base'

module FastHaml
  module FilterCompilers
    class Cdata < Base
      def compile(texts)
        temple = [:multi, [:static, "<![CDATA[\n"]]
        compile_texts(temple, texts, tab_width: 4)
        temple << [:static, "]]>"]
      end
    end

    register(:cdata, Cdata)
  end
end
