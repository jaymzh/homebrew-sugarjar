class Sugarjar < Formula
  desc "Helper utility for a better git/github experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://github.com/jaymzh/sugarjar/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "0a4dab642987d75fac2d82f688885d5297a4fccfe6971ae4a16f3cecfac4baa1"
  license "Apache-2.0"

  depends_on "gh"
  uses_from_macos "ruby", since: :high_sierra

  def install
    ENV["GEM_HOME"] = libexec
    system "bundle", "install"
    system "gem", "build", "sugarjar.gemspec"
    system "gem", "install", "--ignore-dependencies", "sugarjar-#{version}.gem"
    bin.install libexec/"bin/sj"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    output = shell_output("#{bin}/sj lint", 1)
    assert_match "sugarjar must be run from inside a git repo", output
    output = shell_output("#{bin}/sj bclean", 1)
    assert_match "sugarjar must be run from inside a git repo", output
  end
end
