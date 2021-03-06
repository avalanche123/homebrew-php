require 'formula'

class Php54Uuid < Formula
  homepage 'http://pecl.php.net/package/uuid'
  url 'http://pecl.php.net/get/uuid-1.0.2.tgz'
  md5 'c45246bccdaf5e77934be47637627e7f'
  head 'https://svn.php.net/repository/pecl/uuid/trunk', :using => :svn

  depends_on 'autoconf' => :build
  
  def patches
    # fixes build errors on OSX 10.6 and 10.7
    # https://bugs.php.net/bug.php?id=62009
    # https://bugs.php.net/bug.php?id=58311
    p = []
    
    if ARGV.build_head?
      p << "https://raw.github.com/gist/2902360/eb354918f0afff2b4fcd7869d5a49719a2b32312/uuid-trunk.patch"
    else
      p << "https://raw.github.com/gist/2891193/c538ae506aafd1d61f166fa3c1409dca61d100c6/uuid.patch"
    end
    
    return p
  end

  def install
    Dir.chdir "uuid-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/uuid.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php54-uuid:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/uuid.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the uuid module.
      * If you see it, you have been successful!
    EOS
  end
end
