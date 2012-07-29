require 'formula'

class Php53Gmagick < Formula
  homepage 'http://pecl.php.net/package/gmagick'
  url 'http://pecl.php.net/get/gmagick-1.1.0RC3.tgz'
  md5 '105ed64a8efb756207474e47cc6ef59e'
  head 'https://svn.php.net/repository/pecl/gmagick/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'graphicsmagick'

  def install
    Dir.chdir "gmagick-#{version}" unless ARGV.build_head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    system "phpize"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/gmagick.so"
  end

  def caveats; <<-EOS.undent
    To finish installing php53-gmagick:
      * Add the following line to #{etc}/php.ini:
        extension="#{prefix}/gmagick.so"
      * Restart your webserver.
      * Write a PHP page that calls "phpinfo();"
      * Load it in a browser and look for the info on the gmagick module.
      * If you see it, you have been successful!
    EOS
  end
end
