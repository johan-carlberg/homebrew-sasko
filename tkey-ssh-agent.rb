class TkeySshAgent < Formula
  desc "SSH agent for use with the TKey security stick"
  homepage "https://tillitis.se/"
  url "https://github.com/tillitis/tillitis-key1-apps/archive/v0.0.2.tar.gz"
  sha256 "cfb6a6d92ec7b03c985ea8c4e209cbdbb9a5fd327dcc26e3e7c0d0c5b18af06b"
  license "GPL-2.0-only"

  depends_on "go" => :build
  depends_on "tkey-signerapp"

  on_linux do
    depends_on "pinentry"
  end

  on_macos do
    depends_on "pinentry-mac"
  end

  def install
    system "cp", "-af", "#{Formula["tkey-signerapp"].prefix}/bin/app.bin", "cmd/tkey-ssh-agent/"
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "-trimpath", "./cmd/tkey-ssh-agent"
  end

  def post_install
    (var/"run").mkpath
    (var/"log").mkpath
  end

  def caveats
    <<~EOS
      To use this SSH agent, set this variable in your ~/.zshrc and/or ~/.bashrc:
        export SSH_AUTH_SOCK="#{var}/run/tkey-ssh-agent.sock"
    EOS
  end

  service do
    run [opt_bin/"tkey-ssh-agent", "--agent-socket", var/"run/tkey-ssh-agent.sock"]
    keep_alive true
    log_path var/"log/tkey-ssh-agent.log"
    error_log_path var/"log/tkey-ssh-agent.log"

  end

  test do
    socket = testpath/"tkey-ssh-agent.sock"
    fork { exec bin/"tkey-ssh-agent", "--agent-socket", socket }
    sleep 1
    assert_predicate socket, :exist?
  end
end
