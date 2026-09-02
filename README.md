### Building testing images ###
- `git clone https://github.com/freifunk-gluon/gluon.git gluon -b v2025.1.3`
- `cd gluon`
- `git clone https://github.com/Freifunk-Potsdam/site-ffp.git -b testing site`
- `./scripts/container.sh`
- `./site/build_testing.sh`
  or
  `TARGETS="ath79-generic" ./site/build_testing.sh`
