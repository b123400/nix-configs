let

  secrets = (import ./secrets.nix);

  wellKnown = ''
    location ^~ /.well-known/acme-challenge/ {
      default_type "text/plain";
      root /var/www/letsencrypt;
    }

    location = /.well-known/acme-challenge/ {
      return 404;
    }
  '';

  proxyServer = {
    domain,
    internalPort,
    sslEnabled ? false
    }: ''
    server {
      listen 80;
      listen 443 ssl;
      server_name ${domain};

      ${
        if sslEnabled then ''
          ${wellKnown}
          ssl_certificate /etc/letsencrypt/live/${domain}/fullchain.pem;
          ssl_certificate_key /etc/letsencrypt/live/${domain}/privkey.pem;
        '' else ""
      }


      location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_pass http://127.0.0.1:${internalPort}/;
        proxy_redirect off;
      }
    }
  '';

in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx.enable = true;

  services.nginx.httpConfig=''
    server {
      listen       80;
      listen       443 ssl;
      server_name  b123400.net;

      ${wellKnown}
      ssl_certificate /etc/letsencrypt/live/b123400.net/fullchain.pem;
      ssl_certificate_key /etc/letsencrypt/live/b123400.net/privkey.pem;

      autoindex off;

      location / {
        root   /var/www/b123400.net/;
        index  index.html index.htm;
      }
    }

    ${
      proxyServer {
        domain = "blog.b123400.net";
        internalPort = secrets.blog.port;
        sslEnabled = true;
      }
    }

    ${
      proxyServer {
        domain = "danmaku.b123400.net";
        internalPort = secrets.danmaku.port;
        sslEnabled = true;
      }
    }

    ${
      proxyServer {
        domain = "whosetweet.b123400.net";
        internalPort = secrets.whosetweet.port;
        sslEnabled = true;
      }
    }

    server {
        listen 80;
        server_name hotmilktea.com;
        return 301 https://b123400.net;
    }

    server {
         listen       80;
         server_name  but.ai www.but.ai;
         return 301 https://blog.b123400.net/butai-shutdown;
    }
  '';
}

