class Sugarjar < Formula
  desc "Helper utility for a better git/github experience"
  homepage "https://github.com/jaymzh/sugarjar/"
  url "https://github.com/jaymzh/sugarjar/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "0a4dab642987d75fac2d82f688885d5297a4fccfe6971ae4a16f3cecfac4baa1"
  license "Apache-2.0"

  depends_on "gh"
  uses_from_macos "ruby", since: :high_sierra

  {
    "deep_merge"      => {
      "version" => "1.2.2",
      "sha"     => "83ced3a3d7f95f67de958d2ce41b1874e83c8d94fe2ddbff50c8b4b82323563a",
    },
    "mixlib-log"      => {
      "version" => "3.0.9",
      "sha"     => "fd6ca2c8075f8085065dffcee0805c5b3f88d643d5c954acdc3282f463a9ad58",
    },
    "mixlib-shellout" => {
      "version" => "3.2.7",
      "sha"     => "46f6d1f9c77e689a443081c5cac336203343f0f2224db06b80d39ae4cd797c7e",
    },
    "pastel"          => {
      "version" => "0.8.0",
      "sha"     => "481da9fb7d2f6e6b1a08faf11fa10363172dc40fd47848f096ae21209f805a75",
    },
    "chef-utils"      => {
      "version" => "18.3.0",
      "sha"     => "827f7aace26ba9f5f8aca45059644205cc715baded80229f1fd5518d21970701",
    },
    "concurrent-ruby" => {
      "version" => "1.2.2",
      "sha"     => "3879119b8b75e3b62616acc256c64a134d0b0a7a9a3fcba5a233025bcde22c4f",
    },
    "tty-color"       => {
      "version" => "0.6.0",
      "sha"     => "6f9c37ca3a4e2367fb2e6d09722762647d6f455c111f05b59f35730eeb24332a",
    },
  }.each do |gem, info|
    resource gem do
      url "https://rubygems.org/gems/#{gem}-#{info["version"]}.gem"
      sha256 info["sha"]
    end
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    # system "bundle", "install"
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
