{
  openssl,
  pkg-config,
  rustPlatform,
  wezterm,
  lib,
  stdenv,
  perl,
}:

rustPlatform.buildRustPackage {
  pname = "wezterm-headless";
  inherit (wezterm)
    version
    src
    postPatch
    cargoHash
    meta
    ;

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin perl;

  buildInputs = [ openssl ];

  cargoBuildFlags = [
    "--package"
    "wezterm"
    "--package"
    "wezterm-mux-server"
  ];

  doCheck = false;

  postInstall = ''
    install -Dm644 assets/shell-integration/wezterm.sh -t $out/etc/profile.d
    install -Dm644 ${wezterm.passthru.terminfo}/share/terminfo/w/wezterm -t $out/share/terminfo/w
  '';
}
