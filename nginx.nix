let secrets = (import ./secrets.nix);
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  security.acme = {
    defaults.email = "i@b123400.net";
    certs = {
      "b123400.net" = {
        webroot = "/var/www/challenges/b123400.net";
        email = "i@b123400.net";
      };
      "blog.b123400.net" = {
        webroot = "/var/www/challenges/blog.b123400.net";
        email = "i@b123400.net";
      };
    };
    acceptTerms = true;
  };
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
  };
  services.nginx.virtualHosts = {
    "b123400.net" = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = "/var/www/challenges/b123400.net";
      #root = "/var/www/b123400.net";
      locations = {
        "/xliffie/glosseries" = {
          return = "301 https://b123400.net/xliffie/glossary";
        };
        "/" = {
          proxyPass = "http://127.0.0.1:${secrets.website.port}";
          extraConfig = ''
            proxy_redirect off;
          '';
        };
      };
    };

    "carlife.b123400.net" = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = "/var/www/challenges/carlife.b123400.net";
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${secrets.carlife.port}";
          extraConfig = ''
            proxy_redirect off;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "Upgrade";
          '';
        };
      };
    };

    "curio-sity.net" = {
      root = "/var/www/curio-sity.net";
    };

    "blog.b123400.net" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = "/var/www/challenges/blog.b123400.net";
      locations = {
        "/" = {
          return = "301 https://b123400.net/blog$request_uri";
        };
      };
    };

    "is-he.re" = {
      addSSL = true;
      sslCertificate = "/etc/nixos/is-he.re.pem";
      sslCertificateKey = "/etc/nixos/hanepleroma.key";
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:4000";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_redirect off;
            client_max_body_size 100M;
          '';
        };
      };
    };
    "my-diary.is-he.re" = {
      addSSL = true;
      sslCertificate = "/etc/nixos/is-he.re.pem";
      sslCertificateKey = "/etc/nixos/hanepleroma.key";
      locations = {
        "/" = {
          basicAuth = secrets.diary.users;
          proxyPass = "http://127.0.0.1:${secrets.diary.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_redirect off;
          '';
        };
      };
    };
  };
}
