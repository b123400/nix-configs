{ nixpkgs ? import <nixpkgs> {} }:
let secrets = import ./secrets.nix;
    myPleroma = nixpkgs.pleroma.overrideAttrs (old: {
      src = fetchGit {
        url = "https://git.sr.ht/~not/Pleroma";
        rev = "1d574852f4d334ba10d7a775dafd5d7758f41abe";
        allRefs = true;
      };
    });
in
{
  services.pleroma = {
    enable = true;
    configs = [
    ''
      import Config

      config :pleroma, Pleroma.Web.Endpoint,
      url: [host: "is-he.re", scheme: "https", port: 443],
      http: [ip: {127, 0, 0, 1}, port: ${secrets.pleroma.port}]

      config :pleroma, :instance,
      name: "Is Here",
      email: "pleroma@b123400.net",
      notify_email: "pleroma@b123400.net",
      limit: 5000,
      registrations_open: false

      config :pleroma, :media_proxy,
      enabled: false,
      redirect_on_failure: true
      #base_url: "https://cache.pleroma.social"

      config :pleroma, :database, rum_enabled: false
      config :pleroma, :instance, static_dir: "/var/lib/pleroma/static"
      config :pleroma, :instance, max_pinned_statuses: 5
      config :pleroma, :instance, upload_limit: 150_000_000
      config :pleroma, Pleroma.Uploaders.Local, uploads: "/var/lib/pleroma/uploads"
      config :pleroma, configurable_from_database: false
      config :pleroma, :shout, enabled: false

      config :pleroma, Pleroma.Upload,
        filters: [Pleroma.Upload.Filter.Exiftool.StripLocation]

      config :pleroma, :frontend_configurations,
        pleroma_fe: %{
          theme: "is-he.re-brown",
          background: "/images/background.jpg",
          disableChat: true
        }

      config :web_push_encryption, :vapid_details,
        subject: "i@b123400.net",
        public_key: "/etc/pleroma/vapid_public.pem",
        private_key: "/etc/pleroma/vapid_private.pem"

    ''
    ];
    secretConfigFile = "/etc/pleroma/secret.exs";
    package = myPleroma;
  };

  systemd.services.pleroma.serviceConfig.RuntimeMaxSec = "3600s";
  systemd.services.pleroma.serviceConfig.Restart = "always";
  systemd.services.pleroma.path = [ nixpkgs.bash nixpkgs.exiftool ];

  services.postgresql = {
    enable = true;
    package = nixpkgs.postgresql_12;
  };
}
