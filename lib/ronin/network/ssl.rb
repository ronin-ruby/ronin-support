#
# Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This file is part of ronin-support.
#
# ronin-support is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-support is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-support.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/network/tcp'

begin
  require 'openssl'
rescue ::LoadError
  $stderr.puts "WARNING: Ruby was not compiled with OpenSSL support"
end

module Ronin
  module Network
    #
    # Provides helper methods for communicating with SSL-enabled services.
    #
    module SSL
      include TCP

      # Maps SSL verify modes to `OpenSSL::SSL::VERIFY_*` constants.
      #
      # @return [Hash{Symbol => Integer}]
      #
      # @since 1.3.0
      #
      # @api private
      #
      VERIFY = Hash.new do |hash,key|
        verify_const = if key then "VERIFY_#{key.to_s.upcase}"
                       else        'VERIFY_NONE'
                       end

        unless OpenSSL::SSL.const_defined?(verify_const)
          raise(RuntimeError,"unknown verify mode #{key}")
        end

        hash[key] = OpenSSL::SSL.const_get(verify_const)
      end

      #
      # Establishes a SSL connection.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Integer] port
      #   The port to connect to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :local_host
      #   The local host to bind to.
      #
      # @option options [Integer] :local_port
      #   The local port to bind to.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #   May be one of the following:
      #
      #   * `:none`
      #   * `:peer`
      #   * `:client_once`
      #   * `:fail_if_no_peer_cert`
      #
      # @option options [String] :cert
      #   The path to the SSL certificate.
      #
      # @option options [String] :key
      #   The path to the SSL key.
      #
      # @yield [ssl_socket]
      #   The given block will be passed the new SSL Socket.
      #
      # @yieldparam [OpenSSL::SSL::SSLSocket] ssl_socket
      #   The new SSL Socket.
      #
      # @return [OpenSSL::SSL::SSLSocket]
      #   the new SSL Socket.
      #
      # @example
      #   socket = ssl_connect('twitter.com',443)
      #
      # @see https://rubydoc.info/stdlib/openssl/OpenSSL/SSL/SSLSocket
      #
      # @api public
      #
      def ssl_connect(host,port,options={})
        local_host = options[:local_host]
        local_port = options[:local_port]

        cert = options[:cert]
        key  = options[:key]

        socket = tcp_connect(host,port,local_host,local_port)

        ssl_context = OpenSSL::SSL::SSLContext.new()
        ssl_context.verify_mode = SSL::VERIFY[options[:verify]]

        if cert
          ssl_context.cert = OpenSSL::X509::Certificate.new(File.new(cert))
        end

        if key
          ssl_context.key = OpenSSL::PKey::RSA.new(File.new(key))
        end

        ssl_socket = OpenSSL::SSL::SSLSocket.new(socket,ssl_context)
        ssl_socket.sync_close = true
        ssl_socket.connect

        yield ssl_socket if block_given?
        return ssl_socket
      end

      #
      # Creates a new temporary SSL connection.
      #
      # @param [String] host
      #   The host to connect to.
      #
      # @param [Integer] port
      #   The port to connect to.
      #
      # @param [Hash] options
      #   Additional options.
      #
      # @option options [String] :local_host
      #   The local host to bind to.
      #
      # @option options [Integer] :local_port
      #   The local port to bind to.
      #
      # @option options [Symbol] :verify
      #   Specifies whether to verify the SSL certificate.
      #
      # @option options [String] :cert
      #   The path to the SSL certificate.
      #
      # @option options [String] :key
      #   The path to the SSL key.
      #
      # @yield [ssl_socket]
      #   The given block will be passed the temporary SSL Socket.
      #
      # @yieldparam [OpenSSL::SSL::SSLSocket] ssl_socket
      #   The temporary SSL Socket.
      #
      # @return [nil]
      #
      # @example
      #   ssl_session('twitter.com',443) do |sock|
      #     sock.write("GET / HTTP/1.1\n\r\n\r")
      #
      #     sock.each_line { |line| puts line }
      #   end
      #
      # @see https://rubydoc.info/stdlib/openssl/OpenSSL/SSL/SSLSocket
      #
      # @api public
      #
      def ssl_session(host,port,options={},&block)
        ssl_socket = ssl_connect(host,port,options,&block)
        ssl_socket.close
        return nil
      end
    end
  end
end
