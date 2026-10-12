cask "foxcycle" do
  version "0.1.0"
  sha256 "456ffc2ff3eee0f0f1278c15553083f0729a19f184ba154c75601542767cf577"

  url "https://github.com/hongzio/foxcycle/releases/download/v#{version}/FoxCycle-#{version}.zip"
  name "FoxCycle"
  desc "Cycles windows across all Firefox profiles with Cmd+`"
  homepage "https://github.com/hongzio/foxcycle"

  depends_on macos: :sonoma

  app "FoxCycle.app"

  preflight_steps do
    # Self-signed and not notarized: Gatekeeper would refuse to open a quarantined copy.
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{staged_path}}/FoxCycle.app"]
  end

  postflight_steps do
    # An upgrade quits the running copy (see uninstall) and there is no login item: start it again.
    run "/usr/bin/open", args: ["{{appdir}}/FoxCycle.app"], must_succeed: false
  end

  # Also runs on upgrade. Matches installed copies only, not a development build elsewhere.
  uninstall script: {
    executable:   "/usr/bin/pkill",
    args:         ["-f", "Applications/FoxCycle.app/Contents/MacOS/FoxCycle"],
    must_succeed: false,
  }

  zap trash: "~/Library/Preferences/com.hongzio.foxcycle.plist"

  caveats <<~EOS
    FoxCycle needs Accessibility access. Allow it when asked, or in
    System Settings > Privacy & Security > Accessibility.
    It does not start at login: add it in System Settings > General > Login Items.
  EOS
end
