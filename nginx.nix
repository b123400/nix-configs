let secrets = (import ./secrets.nix);
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx.enable = true;
  services.nginx.virtualHosts = {
    "b123400.net" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/b123400.net";
      sslCertificate = "/etc/letsencrypt/live/b123400.net/fullchain.pem";
      sslCertificateKey = "/etc/letsencrypt/live/b123400.net/privkey.pem";
    };

    "blog.b123400.net" = {
      enableACME = true;
      onlySSL = true;
      #enableSSL = true;
      sslCertificate = "/etc/letsencrypt/live/b123400.net/fullchain.pem";
      sslCertificateKey = "/etc/letsencrypt/live/b123400.net/privkey.pem";
      locations = {
        "/" = {
          proxyPass = "http://localhost:${secrets.blog.port}";
          extraConfig = ''
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_set_header X-NginX-Proxy true;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
    "whosetweet.b123400.net" = {
      enableACME = true;
      onlySSL = true;
      #enableSSL = true;
      sslCertificate = "/etc/letsencrypt/live/b123400.net/fullchain.pem";
      sslCertificateKey = "/etc/letsencrypt/live/b123400.net/privkey.pem";
      locations = {
        "/" = {
          proxyPass = "http://localhost:${secrets.whosetweet.port}";
          extraConfig = ''
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_set_header X-NginX-Proxy true;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };
}
