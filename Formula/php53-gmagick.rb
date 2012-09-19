require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php53Gmagick < AbstractPhpExtension
  homepage 'http://pecl.php.net/package/gmagick'
  url 'http://pecl.php.net/get/gmagick-1.1.0RC3.tgz'
  md5 '105ed64a8efb756207474e47cc6ef59e'
  head 'https://svn.php.net/repository/pecl/gmagick/trunk/', :using => :svn

  depends_on 'autoconf' => :build
  depends_on 'graphicsmagick'
  depends_on 'php53' if build.include?('with-homebrew-php') && !Formula.factory('php53').installed?

  def install
    Dir.chdir "gmagick-#{version}" unless build.head?

    # See https://github.com/mxcl/homebrew/pull/5947
    ENV.universal_binary

    safe_phpize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    prefix.install "modules/gmagick.so"
    write_config_file unless build.include? "without-config-file"
  end
end
