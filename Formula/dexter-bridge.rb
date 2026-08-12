class DexterBridge < Formula
  desc "Local Claude Code connector for the Dexter Framer plugin"
  homepage "https://instawebai.com/dexter-bridge"
  url "https://registry.npmjs.org/@gakim-digital/dexter-bridge/-/dexter-bridge-0.5.7.tgz"
  sha256 "5082a15b4c09bc8db73c0b3c554a65c268967be508dd43124fad1383d7ce3795"
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
