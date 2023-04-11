wget -nc http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.7.2.tar.gz
tar -xvzf openfst-1.7.2.tar.gz
git clone https://github.com/AdolfVonKleist/Phonetisaurus.git
git clone https://github.com/mitlm/mitlm.git
mkdir -p model && cd model && wget -nc https://raw.githubusercontent.com/cmusphinx/cmudict/master/cmudict.dict
cat cmudict.dict \
  | perl -pe 's/\([0-9]+\)//;
              s/\s+/ /g; s/^\s+//;
              s/\s+$//; @_ = split (/\s+/);
              $w = shift (@_);
              $_ = $w."\t".join (" ", @_)."\n";' \
  > cmudict.formatted.dict
cd ..              
DOCKER_BUILDKIT=0 docker build -t phonetisaurus .
