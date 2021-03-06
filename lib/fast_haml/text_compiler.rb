require 'strscan'

module FastHaml
  class TextCompiler
    def initialize(escape_html: true)
      @escape_html = escape_html
    end

    def compile(text)
      if contains_interpolation?(text)
        compile_interpolation(text)
      else
        [:static, text]
      end
    end

    private

    INTERPOLATION_BEGIN = /#[\{$@]/o

    def contains_interpolation?(text)
      INTERPOLATION_BEGIN === text
    end

    def compile_interpolation(text)
      s = StringScanner.new(text)
      temple = [:multi]
      pos = s.pos
      while s.scan_until(INTERPOLATION_BEGIN)
        pre = s.string.byteslice(pos ... (s.pos - s.matched.size))
        if pre[-1] == '\\'
          # escaped
          temple << [:static, s.string.byteslice(pos ... (s.pos - s.matched.size - 1))] << [:static, s.matched]
        else
          temple << [:static, pre]
          if s.matched == '#{'
            temple << [:escape, @escape_html, [:dynamic, find_close_brace(s)]]
          else
            var = s.matched[-1]
            s.scan(/\w+/)
            var << s.matched
            temple << [:escape, @escape_html, [:dynamic, var]]
          end
        end
        pos = s.pos
      end
      temple << [:static, s.rest]
      temple
    end

    INTERPOLATION_BRACE = /[\{\}]/o

    def find_close_brace(scanner)
      depth = 1
      pos = scanner.pos
      while depth > 0 && scanner.scan_until(INTERPOLATION_BRACE)
        if scanner.matched == '{'
          depth += 1
        else
          depth -= 1
        end
      end
      scanner.string.byteslice(pos ... (scanner.pos-1))
    end
  end
end
