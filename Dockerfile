FROM docker.io/bitnami/openresty:1.21

USER root

# Copy waf directory to nginx conf directory
COPY waf /opt/bitnami/openresty/nginx/conf/waf

# Add author information
LABEL maintainer="Arterning"

# Add lua settings to nginx.conf
RUN sed -i '/http {/a\    lua_shared_dict limit 50m;\n\
          lua_package_path "/opt/bitnami/openresty/nginx/conf/waf/?.lua";\n\
          init_by_lua_file "/opt/bitnami/openresty/nginx/conf/waf/init.lua";\n\
          access_by_lua_file "/opt/bitnami/openresty/nginx/conf/waf/access.lua";' \
    /opt/bitnami/openresty/nginx/conf/nginx.conf

# Create soft link
RUN ln -s /opt/bitnami/openresty/lualib/resty/ /opt/bitnami/openresty/nginx/conf/waf/resty

USER 1001
