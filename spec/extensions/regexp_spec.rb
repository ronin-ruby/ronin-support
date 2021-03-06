require 'spec_helper'
require 'ronin/extensions/regexp'

describe Regexp do
  describe "WORD" do
    let(:word) { 'dog' }

    subject { Regexp::WORD }

    it "should not match single letters" do
      expect(subject.match('A')).to be_nil
    end

    it "should not match numeric letters" do
      expect(subject.match("123#{word}123")[0]).to eq(word)
    end

    it "should not include ending periods" do
      expect(subject.match("#{word}.")[0]).to eq(word)
    end

    it "should not include leading punctuation" do
      expect(subject.match("'#{word}")[0]).to eq(word)
    end

    it "should not include tailing punctuation" do
      expect(subject.match("#{word}'")[0]).to eq(word)
    end

    it "should include punctuation in the middle of the word" do
      name = "O'Brian"

      expect(subject.match(name)[0]).to eq(name)
    end
  end

  describe "OCTET" do
    subject { Regexp::OCTET }

    it "should match 0 - 255" do
      expect((0..255).all? { |n|
        subject.match(n.to_s)[0] == n.to_s
      }).to be(true)
    end

    it "should not match numbers greater than 255" do
      expect(subject.match('256')[0]).to eq('25')
    end
  end

  describe "MAC" do
    subject { Regexp::MAC }

    it "should match six hexadecimal bytes" do
      mac = '12:34:56:78:9a:bc'

      expect(subject.match(mac)[0]).to eq(mac)
    end
  end

  describe "IPv4" do
    subject { Regexp::IPv4 }

    it "should match valid addresses" do
      ip = '127.0.0.1'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "should match the Any address" do
      ip = '0.0.0.0'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "should match the broadcast address" do
      ip = '255.255.255.255'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "should match addresses with netmasks" do
      ip = '10.1.1.1/24'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "should not match addresses with octets > 255" do
      ip = '10.1.256.1'

      expect(subject.match(ip)).to be_nil
    end

    it "should not match addresses with more than three digits per octet" do
      ip = '10.1111.1.1'

      expect(subject.match(ip)).to be_nil
    end
  end

  describe "IPv6" do
    subject { Regexp::IPv6 }

    it "should match valid IPv6 addresses" do
      ip = '2001:db8:85a3:0:0:8a2e:370:7334'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "should match IPv6 addresses with netmasks" do
      ip = '2001:db8:1234::/48'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "should match truncated IPv6 addresses" do
      ip = '2001:db8:85a3::8a2e:370:7334'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "should match IPv4-mapped IPv6 addresses" do
      ip = '::ffff:192.0.2.128'

      expect(subject.match(ip)[0]).to eq(ip)
    end
  end

  describe "IP" do
    subject { Regexp::IP }

    it "should match IPv4 addresses" do
      ip = '10.1.1.1'

      expect(subject.match(ip)[0]).to eq(ip)
    end

    it "should match IPv6 addresses" do
      ip = '2001:db8:85a3:0:0:8a2e:370:7334'

      expect(subject.match(ip)[0]).to eq(ip)
    end
  end

  describe "HOST_NAME" do
    subject { Regexp::HOST_NAME }

    it "should match valid hostnames" do
      hostname = 'www.google.com'

      expect(subject.match(hostname)[0]).to eq(hostname)
    end

    it "should not match hostnames without a TLD" do
      expect(subject.match('foo')).to be_nil
    end

    it "should not match hostnames with unknown TLDs" do
      expect(subject.match('foo.zzz')).to be_nil
    end
  end

  describe "USER_NAME" do
    subject { Regexp::USER_NAME }

    it "should match valid user-names" do
      username = 'alice1234'

      expect(subject.match(username)[0]).to eq(username)
    end

    it "should match user-names containing '_' characters" do
      username = 'alice_1234'

      expect(subject.match(username)[0]).to eq(username)
    end

    it "should match user-names containing '.' characters" do
      username = 'alice.1234'

      expect(subject.match(username)[0]).to eq(username)
    end

    it "should not match user-names beginning with numbers" do
      expect(subject.match('1234bob')[0]).to eq('bob')
    end

    it "should not match user-names containing spaces" do
      expect(subject.match('alice eve')[0]).to eq('alice')
    end

    it "should not match user-names containing other symbols" do
      expect(subject.match('alice^eve')[0]).to eq('alice')
    end
  end

  describe "EMAIL_ADDR" do
    subject { Regexp::EMAIL_ADDR }

    it "should match valid email addresses" do
      email = 'alice@example.com'

      expect(subject.match(email)[0]).to eq(email)
    end
  end

  describe "PHONE_NUMBER" do
    subject { Regexp::PHONE_NUMBER }

    it "should match 111-2222" do
      number = '111-2222'

      expect(subject.match(number)[0]).to eq(number)
    end

    it "should match 111-2222x9" do
      number = '111-2222x9'

      expect(subject.match(number)[0]).to eq(number)
    end

    it "should match 800-111-2222" do
      number = '800-111-2222'

      expect(subject.match(number)[0]).to eq(number)
    end

    it "should match 1-800-111-2222" do
      number = '1-800-111-2222'

      expect(subject.match(number)[0]).to eq(number)
    end
  end

  describe "IDENTIFIER" do
    subject { Regexp::IDENTIFIER }

    it "should match Strings beginning with a '_' character" do
      identifier = '_foo'

      expect(subject.match(identifier)[0]).to eq(identifier)
    end

    it "should match Strings ending with a '_' character" do
      identifier = 'foo_'

      expect(subject.match(identifier)[0]).to eq(identifier)
    end

    it "should not match Strings beginning with numberic characters" do
      expect(subject.match('1234foo')[0]).to eq('foo')
    end

    it "should not match Strings not containing any alpha characters" do
      identifier = '_1234_'

      expect(subject.match(identifier)).to be_nil
    end
  end

  describe "FILE_EXT" do
    subject { Regexp::FILE_EXT }

    it "should match the '.' separator character" do
      ext = '.txt'

      expect(subject.match(ext)[0]).to eq(ext)
    end

    it "should not allow '_' characters" do
      expect(subject.match('.foo_bar')[0]).to eq('.foo')
    end

    it "should not allow '-' characters" do
      expect(subject.match('.foo-bar')[0]).to eq('.foo')
    end
  end

  describe "FILE_NAME" do
    subject { Regexp::FILE_NAME }

    it "should match file names" do
      filename = 'foo_bar'

      expect(subject.match(filename)[0]).to eq(filename)
    end

    it "should match '\\' escapped characters" do
      filename = 'foo\\ bar'

      expect(subject.match(filename)[0]).to eq(filename)
    end
  end

  describe "FILE" do
    subject { Regexp::FILE }

    it "should match the filename and extension" do
      filename = 'foo_bar.txt'

      expect(subject.match(filename)[0]).to eq(filename)
    end
  end

  describe "DIRECTORY" do
    subject { Regexp::DIRECTORY }

    it "should match directory names" do
      dir = 'foo_bar'

      expect(subject.match(dir)[0]).to eq(dir)
    end

    it "should match '.'" do
      dir = '.'

      expect(subject.match(dir)[0]).to eq(dir)
    end

    it "should match '..'" do
      dir = '..'

      expect(subject.match(dir)[0]).to eq(dir)
    end
  end

  describe "RELATIVE_UNIX_PATH" do
    subject { Regexp::RELATIVE_UNIX_PATH }

    it "should match multiple directories" do
      path = 'foo/./bar/../baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end

  describe "ABSOLUTE_UNIX_PATH" do
    subject { Regexp::ABSOLUTE_UNIX_PATH }

    it "should match absolute paths" do
      path = '/foo/bar/baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "should match trailing '/' characters" do
      path = '/foo/bar/baz/'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "should not match relative directories" do
      path = '/foo/./bar/../baz'

      expect(subject.match(path)[0]).to eq('/foo/')
    end
  end

  describe "UNIX_PATH" do
    subject { Regexp::UNIX_PATH }

    it "should match relative paths" do
      path = 'foo/./bar/../baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "should match absolute paths" do
      path = '/foo/bar/baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end

  describe "RELATIVE_WINDOWS_PATH" do
    subject { Regexp::RELATIVE_WINDOWS_PATH }

    it "should match multiple directories" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end

  describe "ABSOLUTE_WINDOWS_PATH" do
    subject { Regexp::ABSOLUTE_WINDOWS_PATH }

    it "should match absolute paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "should match trailing '/' characters" do
      path = 'C:\\foo\\bar\\baz\\'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "should not match relative directories" do
      path = 'C:\\foo\\.\\bar\\..\\baz'

      expect(subject.match(path)[0]).to eq('C:\\foo\\')
    end
  end

  describe "WINDOWS_PATH" do
    subject { Regexp::WINDOWS_PATH }

    it "should match relative paths" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "should match absolute paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end

  describe "RELATIVE_PATH" do
    subject { Regexp::RELATIVE_PATH }

    it "should match relative UNIX paths" do
      path = 'foo/./bar/../baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "should match relative Windows paths" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end

  describe "ABSOLUTE_PATH" do
    subject { Regexp::ABSOLUTE_PATH }

    it "should match absolute UNIX paths" do
      path = '/foo/bar/baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "should match absolute Windows paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end

  describe "PATH" do
    subject { Regexp::PATH }

    it "should match relative UNIX paths" do
      path = 'foo/./bar/../baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "should match absolute UNIX paths" do
      path = '/foo/bar/baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "should match relative Windows paths" do
      path = 'foo\\.\\bar\\..\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end

    it "should match absolute Windows paths" do
      path = 'C:\\foo\\bar\\baz'

      expect(subject.match(path)[0]).to eq(path)
    end
  end
end
