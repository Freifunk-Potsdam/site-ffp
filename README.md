# Freifunk Potsdam Site Configuration

This is the [Gluon site configuration](https://gluon.readthedocs.io/en/latest/user/site.html)
of the Freifunk Potsdam community. It includes scripts to build and upload 
images/packages.

## Build requirements

To build the images the use of Docker or Podman is recommended. Alternatively
a Debian system with the [dependencies](https://gluon.readthedocs.io/en/latest/user/getting_started.html#dependencies)
described in the Gluon documentation should work.

For signing the a key pair must be generated.

## Generate a key pair

Checkout and build the [ECDSA Util](https://github.com/freifunk-gluon/ecdsautils)
as described in the provided README.md. Note the build dependency `libuecc`. On
Debian based systems `libuecc-dev` should be installed to build.

Also note that the binary is not added to your `PATH`. Since it is only used 
once, it can be called by the the full path.

```shell
# generate a private key
$ ecdsautil generate-key > secret
# generate public key from private
$ ecdsautil show-key < secret > public
```

The filename does not matter. It can also be named like ssh keys, for example:
`id_ecdsa` for the secret (private) key and `id_ecdsa.pub` for the public key.

It is also a good practice to change the the permissions of the secret (private)
key to read/write only by the user with `chmod 600 <secret-key-file>`. 

## Build (testing)

- `git clone https://github.com/Freifunk-Potsdam/gluon.git gluon -b v2022.1.3-ffp`  
  This is a fork where client isolation is added. Until the [PR](https://github.com/freifunk-gluon/gluon/pull/2714)
  is not merged into upstream and is finally in a release we depend of our own
  fork.
- `cd gluon`
- `git clone https://github.com/Freifunk-Potsdam/site-ffp.git site -b testing`
- start build container `./scripts/container.sh`
- in container: `./site/build_testing.sh ~/secret`  
  Note: Make sure the `secret` is located in the `gluon` directory.

## References

- https://gluon.readthedocs.io/en/latest/user/getting_started.html
- https://wiki.ffnw.de/Firmware/Releaseprozess#Allgemeines_zu_Signaturen
- https://gluon.readthedocs.io/en/latest/user/getting_started.html#signing-keys
- https://github.com/freifunk-gluon/ecdsautils