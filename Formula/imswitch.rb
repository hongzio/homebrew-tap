class Imswitch < Formula
  desc "Force the macOS input source from Neovim, locally or over SSH"
  homepage "https://github.com/hongzio/imswitch"
  license "MIT"
  head "https://github.com/hongzio/imswitch.git", branch: "main"

  # No Xcode requirement. `depends_on xcode: :clt` is a trap: XcodeRequirement
  # parses only a version string off its tags, so :clt is ignored and a full
  # Xcode.app is demanded — the build then fails on a Command Line Tools machine
  # with "A full installation of Xcode.app is required". Homebrew already
  # requires the CLT, which is all build.sh needs.
  depends_on :macos

  def install
    system "./build.sh"
    prefix.install "build/Imswitch.app"
    bin.install_symlink prefix/"Imswitch.app/Contents/MacOS/imswitch"
  end

  service do
    run [opt_prefix/"Imswitch.app/Contents/MacOS/imswitch", "serve"]
    keep_alive true
    process_type :interactive # avoid App Nap; ':' latency is felt
    log_path var/"log/imswitch.log"
    error_log_path var/"log/imswitch.log"
  end

  test do
    assert_match "imswitch", shell_output("#{bin}/imswitch --help")
    # The bind address is load-bearing in the snippet, so assert on it.
    assert_match "RemoteForward 127.0.0.1:57377", shell_output("#{bin}/imswitch ssh-config")
    assert_match "ClearAllForwardings yes", shell_output("#{bin}/imswitch ssh-config")
  end
end
