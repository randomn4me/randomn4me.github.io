{ pkgs, src }:

pkgs.writeShellScriptBin "serve-blog" ''
  # Serve on 0.0.0.0 to allow both localhost and 127.0.0.1 access
  echo "Server starting at http://localhost:1111"
  ${pkgs.zola}/bin/zola serve --interface 0.0.0.0 --port 1111
''