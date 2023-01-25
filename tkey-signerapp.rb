class TkeySignerapp < Formula
  desc "A ed25519 message signer, for use on a TKey security stick"
  homepage "https://tillitis.se/"
  url "https://github.com/tillitis/tillitis-key1-apps/archive/v0.0.2.tar.gz"
  sha256 "cfb6a6d92ec7b03c985ea8c4e209cbdbb9a5fd327dcc26e3e7c0d0c5b18af06b"
  env :std
  license :all_of: ["GPL-2.0-only", "CC0-1.0"]

  depends_on "llvm" => :build
  depends_on "ninja" => :build

  fails_with :clang do
    build 1500
    cause "Requires riscv32 support and Zmmul extension"
  end

  def install
    system "make", "apps"
    bin.install "apps/signer/app.bin"
  end
end
