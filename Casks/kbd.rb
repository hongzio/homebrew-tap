cask "kbd" do
  version "0.1.2"
  sha256 "5e01c7ca0e2ee895aeda78f31e3673f9658987defd79fb915ecd82385ae1042e"

  url "https://github.com/hongzio/kbd/releases/download/v#{version}/kbd-#{version}.zip"
  name "kbd"
  desc "Korean input method for developers"
  homepage "https://github.com/hongzio/kbd"

  depends_on macos: :sonoma

  input_method "kbd.app"

  preflight_steps do
    # Ad-hoc signed and not notarized: without this macOS runs a translocated copy.
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{staged_path}}/kbd.app"]
  end

  postflight_steps do
    # The input menu caches the input source icon; launchd restarts it.
    terminate_process "TextInputMenuAgent"
  end

  # Also runs on upgrade. SIGTERM makes kbd remove its key remapping and sockets; the system
  # starts the new version on the next keystroke.
  uninstall script: {
    executable:   "/usr/bin/pkill",
    args:         ["-f", "Input Methods/kbd.app/Contents/MacOS/kbd"],
    must_succeed: false,
  }

  zap trash: [
    "~/.config/kbd",
    "~/.local/state/kbd",
  ]

  caveats <<~EOS
    Add kbd in System Settings > Keyboard > Input Sources > Edit > + > Korean.
    If kbd isn't listed there, log out and back in.
  EOS
end
