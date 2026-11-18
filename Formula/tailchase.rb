class Tailchase < Formula
  desc "Manage tailcat aliases, keys, and persistent connections"
  homepage "https://github.com/hongzio/tailchase"
  head "https://github.com/hongzio/tailchase.git", branch: "main"

  depends_on "go" => :build
  depends_on "tailcat"

  def install
    system "go", "build", "-trimpath", "-o", bin/"tailchase", "./cmd/tailchase"
  end

  service do
    run [opt_bin/"tailchase", "daemon"]
    environment_variables PATH: "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    keep_alive true
    log_path var/"log/tailchase.log"
    error_log_path var/"log/tailchase.log"
  end

  test do
    assert_match "tailchase", shell_output("#{bin}/tailchase --help")
    assert_match "daemon: offline", shell_output("TAILCHASE_CONFIG_DIR=#{testpath}/config #{bin}/tailchase status")
  end
end
