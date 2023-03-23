# Ruby 3 removed the URI.escape method
# One of our dependencies is still using it and I
# can't figure out which one! So here is a monkey-patch
# from https://stackoverflow.com/a/69950308

require 'uri'

module URI
    class << self
        def escape(str)
            alpha = "a-zA-Z"
            alnum = "#{alpha}\\d"
            unreserved = "\\-_.!~*'()#{alnum}"
            reserved = ";/?:@&=+$,\\[\\]"
            unsafe = Regexp.new("[^#{unreserved}#{reserved}]")
            str.gsub(unsafe) do
                us = $&
                tmp = ''
                us.each_byte do |uc|
                    tmp << sprintf('%%%02X', uc)
                end
                tmp
            end.force_encoding(Encoding::US_ASCII)
        end
    end
end