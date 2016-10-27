let
  wellKnown = ''
    location ^~ /.well-known/acme-challenge/ {
      default_type "text/plain";
      root /var/www/letsencrypt;
    }

    location = /.well-known/acme-challenge/ {
      return 404;
    }
  '';

  secrets = (import ./secrets.nix);

in
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  services.nginx.httpConfig=''
    server {
      listen       80;
      listen       443 ssl;
      server_name  b123400.net www.b123400.net;

      ${wellKnown}
      ssl_certificate /etc/letsencrypt/live/b123400.net/fullchain.pem;
      ssl_certificate_key /etc/letsencrypt/live/b123400.net/privkey.pem;

      autoindex off;

      location / {
        root   /var/www/b123400.net/;
        index  index.html index.htm;
      }
    }

    server {
      listen 80;
      listen 443 ssl;
      server_name  blog.b123400.net;

      ${wellKnown}
      ssl_certificate /etc/letsencrypt/live/blog.b123400.net/fullchain.pem;
      ssl_certificate_key /etc/letsencrypt/live/blog.b123400.net/privkey.pem;

      location / {
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-NginX-Proxy true;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_pass http://127.0.0.1:${secrets.blog.port}/;
        proxy_redirect off;
      }
    }

    server {
        listen 80;
        listen 443 ssl;
        server_name danmaku.b123400.net;

        ${wellKnown}
        ssl_certificate /etc/letsencrypt/live/danmaku.b123400.net/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/danmaku.b123400.net/privkey.pem;

        location / {
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $http_host;
            proxy_set_header X-NginX-Proxy true;

            proxy_pass http://127.0.0.1:${secrets.danmaku.port}/;
            proxy_redirect off;
        }
    }

    server {
        listen 80;
        listen 443 ssl;
        server_name whosetweet.b123400.net;

        ${wellKnown}
        ssl_certificate /etc/letsencrypt/live/whosetweet.b123400.net/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/whosetweet.b123400.net/privkey.pem;

        location / {
             proxy_set_header X-Real-IP $remote_addr;
             proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
             proxy_set_header Host $http_host;
             proxy_set_header X-NginX-Proxy true;

             proxy_pass http://127.0.0.1:${secrets.whosetweet.port}/;
             proxy_redirect off;
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

