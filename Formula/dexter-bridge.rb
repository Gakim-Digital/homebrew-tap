class DexterBridge < Formula
  desc "Local Codex and Claude Code bridge for InstaWebAI and Dexter"
  homepage "https://instawebai.com/dexter-bridge"
  url "https://registry.npmjs.org/@gakim-digital/dexter-bridge/-/dexter-bridge-0.5.21.tgz"
  sha256 "4563d29ac7e45838b2320f77ec53254a1b74e8fd883dd46548e5f28ec3109eef"
  license :cannot_represent

  depends_on "node@22"

  def install
    ENV.prepend_path "PATH", formula_opt_bin("node@22")
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  service do
    run [opt_bin/"dexter-bridge", "start", "--agent", "claude-code"]
    keep_alive true
    process_type :background
    log_path var/"log/dexter-bridge.log"
    error_log_path var/"log/dexter-bridge.error.log"
    environment_variables PATH:                         "#{formula_opt_bin("node@22")}:#{std_service_path_env}",
                          DEXTER_BRIDGE_INSTALL_METHOD: "homebrew"
  end

  test do
    assert_match "Local Agent Bridge for Dexter and InstaWebAI", shell_output("#{bin}/dexter-bridge --help")
  end
end
