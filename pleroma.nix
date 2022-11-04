{ nixpkgs ? import <nixpkgs> {} }:
{
  services.pleroma = {
    enable = true;
    configs = [
    ''
      import Config

      config :pleroma, Pleroma.Web.Endpoint,
      url: [host: "is-he.re", scheme: "https", port: 443],
      http: [ip: {127, 0, 0, 1}, port: 4000]

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

      config :pleroma, :frontend_configurations,
        pleroma_fe: %{
          theme: "is-he.re-brown",
          background: "/images/background.jpg",
          disableChat: true
        }
    ''
    ];
    secretConfigFile = "/etc/pleroma/secret.exs";
    package = nixpkgs.pleroma-otp;
  };

  systemd.services.pleroma.serviceConfig.RuntimeMaxSec = "3600s";
  systemd.services.pleroma.serviceConfig.Restart = "always";

  services.postgresql = {
    enable = true;
    package = nixpkgs.postgresql_12;
  };
}
