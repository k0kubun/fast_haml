module Faml
  # Don't use these methods!

  module Helpers
    def self.preserve(input)
      # Taken from the original haml code
      input.to_s.chomp("\n").gsub(/\n/, '&#x000A;').gsub(/\r/, '')
    end

    def preserve(input)
      Helpers.preserve(input)
    end
  end
end