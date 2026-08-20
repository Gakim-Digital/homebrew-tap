class DexterBridge < Formula
  desc "Local Claude Code connector for the Dexter Framer plugin"
  homepage "https://instawebai.com/dexter-bridge"
  url "https://registry.npmjs.org/@gakim-digital/dexter-bridge/-/dexter-bridge-0.5.19.tgz"
  sha256 "fc6f7de4669a9bc69c598a4449bc0a2398d8177cc3ea04a9e2677e93e078a4bb"
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
    assert_match "Dexter Bridge", shell_output("#{bin}/dexter-bridge --help")
  end
end
