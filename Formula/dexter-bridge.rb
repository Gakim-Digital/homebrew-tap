class DexterBridge < Formula
  desc "Local Claude Code connector for the Dexter Framer plugin"
  homepage "https://instawebai.com/dexter-bridge"
  url "https://registry.npmjs.org/@gakim-digital/dexter-bridge/-/dexter-bridge-0.5.1.tgz"
  sha256 "bacec58c4ab8ba055190168f41b819054e4f36389fbef153dca0dcf5302a0ce7"
  license :cannot_represent

  depends_on "node@22"

  def install
    ENV.prepend_path "PATH", Formula["node@22"].opt_bin
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  service do
    run [opt_bin/"dexter-bridge", "start", "--agent", "claude-code"]
    keep_alive true
    process_type :background
    log_path var/"log/dexter-bridge.log"
    error_log_path var/"log/dexter-bridge.error.log"
    environment_variables PATH: "#{Formula["node@22"].opt_bin}:#{std_service_path_env}",
                          DEXTER_BRIDGE_INSTALL_METHOD: "homebrew"
  end

  test do
    assert_match "Dexter Bridge", shell_output("#{bin}/dexter-bridge --help")
  end
end
