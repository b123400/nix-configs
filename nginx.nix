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
      "todo.b123400.net" = {
        webroot = "/var/www/challenges/todo.b123400.net";
        email = "i@b123400.net";
      };
      "ferry.b123400.net" = {
        webroot = "/var/www/challenges/ferry.b123400.net";
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

    "blog.b123400.net" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = "/var/www/challenges/blog.b123400.net";
      locations = {
        "/" = {
          proxyPass = "http://localhost:${secrets.blog.port}";
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
          proxyPass = "http://localhost:${secrets.whosetweet.port}";
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

    "todo.b123400.net" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = "/var/www/challenges/todo.b123400.net";
      locations = {
        "/" = {
          proxyPass = "http://localhost:${secrets.todograph.port}";
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
    
    "ferry.b123400.net" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = "/var/www/challenges/ferry.b123400.net";
      locations = {
        "/" = {
          proxyPass = "http://localhost:${secrets.ferry.port}";
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
  };
}
