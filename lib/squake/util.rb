# typed: strict
# frozen_string_literal: true

module Squake
  class Util
    extend T::Sig

    # Encodes a hash of parameters in a way that's suitable for use as query
    # parameters in a URI or as form parameters in a request body. This mainly
    # involves escaping special characters from parameter keys and values (e.g.
    # `&`).
    sig { params(params: T::Hash[Symbol, String]).returns(String) }
    def self.encode_parameters(params)
      params.map { |k, v| "#{url_encode(k.to_s)}=#{url_encode(v)}" }.join('&')
    end

    # Encodes a string in a way that makes it suitable for use in a set of
    # query parameters in a URI or in a set of form parameters in a request
    # body.
    sig { params(key: String).returns(String) }
    def self.url_encode(key)
      CGI.escape(key.to_s).
        # Don't use strict form encoding by changing the square bracket control
        # characters back to their literals. This is fine by the server, and
        # makes these parameter strings easier to read.
        gsub('%5B', '[').gsub('%5D', ']')
    end
  end
end
