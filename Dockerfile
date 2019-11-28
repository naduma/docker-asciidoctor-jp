FROM asciidoctor/docker-asciidoctor

RUN blockDiagFont='/usr/share/fonts/noto/NotoSansMonoCJKjp-Regular.otf' \
  && mkdir /tmp/noto \
  && curl -o /tmp/noto/font.zip https://noto-website.storage.googleapis.com/pkgs/NotoSansCJKjp-hinted.zip \
  && unzip /tmp/noto/font.zip -d /tmp/noto \
  && mkdir -p /usr/share/fonts/noto \
  && cp /tmp/noto/*.otf /usr/share/fonts/noto \
  && chmod 644 -R /usr/share/fonts/noto/ \
  && fc-cache -fv \
  && rm -rf /tmp/noto \
  && mkdir -p mkdir -p /usr/lib/jvm/java-1.8-openjdk/jre/lib/fonts/fallback \
  && ln -s /usr/share/fonts/noto/* /usr/lib/jvm/java-1.8-openjdk/jre/lib/fonts/fallback/ \
  && echo -e "[blockdiag]\nfontpath = $blockDiagFont\n[seqdiag]\nfontpath = $blockDiagFont\n[actdiag]\nfontpath = $blockDiagFont\n[nwdiag]\nfontpath = $blockDiagFont\n[rackdiag]\nfontpath = $blockDiagFont\n[packetdiag]\nfontpath = $blockDiagFont" > /root/.blockdiagrc \
  && gem install asciidoctor-pdf-cjk asciidoctor-rouge -N \
  && echo 'Prawn::Svg::Font::GENERIC_CSS_FONT_MAPPING.merge!('\''sans-serif'\'' => '\''M+ 1p Fallback'\'')' > /usr/lib/ruby/gems/2.5.0/gems/asciidoctor-pdf-1.5.0.beta.7/lib/prawn_svg_patch.rb \
  && echo -e '#!/bin/sh\n\nasciidoctor -r asciidoctor-diagram "$@"' > /usr/local/bin/adoc \
  && echo -e '#!/bin/sh\n\nasciidoctor-pdf -r asciidoctor-pdf-cjk -r asciidoctor-diagram -r prawn_svg_patch.rb -a pdf-style=default-with-fallback-font "$@"' > /usr/local/bin/adoc-pdf \
  && chmod +x /usr/local/bin/adoc /usr/local/bin/adoc-pdf
