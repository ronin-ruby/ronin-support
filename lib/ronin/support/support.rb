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

require 'ronin/ui/output'
require 'ronin/network'

module Ronin
  #
  # The main namespace for `ronin-support`.
  #
  module Support
    include UI::Output::Helpers
    include Network::DNS
    include Network::TCP
    include Network::UDP
    include Network::SSL
    include Network::UNIX
    include Network::SMTP
    include Network::ESMTP
    include Network::POP3
    include Network::IMAP
    include Network::Telnet
    include Network::FTP
    include Network::HTTP
  end
end
