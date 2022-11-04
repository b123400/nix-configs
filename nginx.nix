let secrets = (import ./secrets.nix);
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx.enable = true;
  security.acme = {
    certs = {
      "b123400.net" = {
        webroot = "/var/www/challenges/b123400.net";
        email = "i@b123400.net";
      };
      "blog.b123400.net" = {
        webroot = "/var/www/challenges/blog.b123400.net";
        email = "i@b123400.net";
      };
      "whosetweet.b123400.net" = {
        webroot = "/var/www/challenges/whosetweet.b123400.net";
        email = "i@b123400.net";
      };
      /*"todo.b123400.net" = {
        webroot = "/var/www/challenges/todo.b123400.net";
        email = "i@b123400.net";
      };*/
      "ferry.b123400.net" = {
        webroot = "/var/www/challenges/ferry.b123400.net";
        email = "i@b123400.net";
      };
      "matomo.b123400.net" = {
        email = "i@b123400.net";
      };
    };
    acceptTerms = true;
  };
  services.nginx.virtualHosts = {
    "b123400.net" = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = "/var/www/challenges/b123400.net";
      root = "/var/www/b123400.net";
    };

    "curio-sity.net" = {
      root = "/var/www/curio-sity.net";
    };
    "www.curio-sity.net" = {
      root = "/var/www/curio-sity.net";
    };

    "blog.b123400.net" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = "/var/www/challenges/blog.b123400.net";
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${secrets.blog.port}";
          extraConfig = ''
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
            proxy_set_header X-NginX-Proxy true;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };

    "whosetweet.b123400.net" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = "/var/www/challenges/whosetweet.b123400.net";
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${secrets.whosetweet.port}";
          extraConfig = ''
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
            proxy_set_header X-NginX-Proxy true;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };

/*
    "todo.b123400.net" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = "/var/www/challenges/todo.b123400.net";
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${secrets.todograph.port}";
          extraConfig = ''
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
            proxy_set_header X-NginX-Proxy true;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
*/

    "ferry.b123400.net" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = "/var/www/challenges/ferry.b123400.net";
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:${secrets.ferry.port}";
          extraConfig = ''
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
            proxy_set_header X-NginX-Proxy true;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };

    "is-he.re" = {
      #enableACME = true;
      #forceSSL = true;
      #acmeRoot = "/var/www/challenges/is-he.re";
      addSSL = true;
      sslCertificate = "/etc/nixos/is-he.re.pem";
      sslCertificateKey = "/etc/nixos/hanepleroma.key";
      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:4000";
          extraConfig = ''
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
            proxy_set_header X-NginX-Proxy true;
            proxy_set_header X-Forwarded-Proto $scheme;

            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
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
          extraConfig = ''
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
            proxy_set_header X-NginX-Proxy true;
            proxy_set_header X-Forwarded-Proto $scheme;

            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
      };
    };
  };
}
