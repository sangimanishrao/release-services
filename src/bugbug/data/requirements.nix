# generated using pypi2nix tool (version: 2.0.0)
# See more at: https://github.com/garbas/pypi2nix
#
# COMMAND:
#   pypi2nix -v -C /app/src/bugbug/data/../../../tmp/pypi2nix -V 3.7 -O ../../../nix/requirements_override.nix -E blas -E gfortran -E libffi -E openssl -E pkgconfig -E freetype.dev -E libjpeg.dev -E hdf5 -s numpy -s flit -s intreehooks -s cython -s pkgconfig -e pytest-runner -e setuptools-scm -r requirements.txt -r requirements-dev.txt
#

{ pkgs ? import <nixpkgs> {},
  overrides ? ({ pkgs, python }: self: super: {})
}:

let

  inherit (pkgs) makeWrapper;
  inherit (pkgs.stdenv.lib) fix' extends inNixShell;

  pythonPackages =
  import "${toString pkgs.path}/pkgs/top-level/python-packages.nix" {
    inherit pkgs;
    inherit (pkgs) stdenv;
    python = pkgs.python37;
    # patching pip so it does not try to remove files when running nix-shell
    overrides =
      self: super: {
        bootstrapped-pip = super.bootstrapped-pip.overrideDerivation (old: {
          patchPhase = old.patchPhase + ''
            if [ -e $out/${pkgs.python37.sitePackages}/pip/req/req_install.py ]; then
              sed -i \
                -e "s|paths_to_remove.remove(auto_confirm)|#paths_to_remove.remove(auto_confirm)|"  \
                -e "s|self.uninstalled = paths_to_remove|#self.uninstalled = paths_to_remove|"  \
                $out/${pkgs.python37.sitePackages}/pip/req/req_install.py
            fi
          '';
        });
      };
  };

  commonBuildInputs = with pkgs; [ blas gfortran libffi openssl pkgconfig freetype.dev libjpeg.dev hdf5 ];
  commonDoCheck = false;

  withPackages = pkgs':
    let
      pkgs = builtins.removeAttrs pkgs' ["__unfix__"];
      interpreterWithPackages = selectPkgsFn: pythonPackages.buildPythonPackage {
        name = "python37-interpreter";
        buildInputs = [ makeWrapper ] ++ (selectPkgsFn pkgs);
        buildCommand = ''
          mkdir -p $out/bin
          ln -s ${pythonPackages.python.interpreter} \
              $out/bin/${pythonPackages.python.executable}
          for dep in ${builtins.concatStringsSep " "
              (selectPkgsFn pkgs)}; do
            if [ -d "$dep/bin" ]; then
              for prog in "$dep/bin/"*; do
                if [ -x "$prog" ] && [ -f "$prog" ]; then
                  ln -s $prog $out/bin/`basename $prog`
                fi
              done
            fi
          done
          for prog in "$out/bin/"*; do
            wrapProgram "$prog" --prefix PYTHONPATH : "$PYTHONPATH"
          done
          pushd $out/bin
          ln -s ${pythonPackages.python.executable} python
          ln -s ${pythonPackages.python.executable} \
              python3
          popd
        '';
        passthru.interpreter = pythonPackages.python;
      };

      interpreter = interpreterWithPackages builtins.attrValues;
    in {
      __old = pythonPackages;
      inherit interpreter;
      inherit interpreterWithPackages;
      mkDerivation = pythonPackages.buildPythonPackage;
      packages = pkgs;
      overrideDerivation = drv: f:
        pythonPackages.buildPythonPackage (
          drv.drvAttrs // f drv.drvAttrs // { meta = drv.meta; }
        );
      withPackages = pkgs'':
        withPackages (pkgs // pkgs'');
    };

  python = withPackages {};

  generated = self: {
    "Click" = python.mkDerivation {
      name = "Click-7.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz";
        sha256 = "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://palletsprojects.com/p/click/";
        license = licenses.bsdOriginal;
        description = "Composable command line interface toolkit";
      };
    };

    "Cython" = python.mkDerivation {
      name = "Cython-0.29.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/cf/e2/03af631ca4a2cf7bc392dd8785c7cc427bff3af4bf5864cdde734f80d052/Cython-0.29.4.tar.gz";
        sha256 = "d1ee3d39c73a094ae5b6e2f9263ae0dc61af1b549a0869ade8c3c30325ed9f26";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://cython.org/";
        license = "Apache";
        description = "The Cython compiler for writing C extensions for the Python language.";
      };
    };

    "Keras" = python.mkDerivation {
      name = "Keras-2.2.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/13/5c/11b1d1e709cfb680cf5cc592f8e37d3db19871ee5c5cc0d9ddbae4e911c7/Keras-2.2.4.tar.gz";
        sha256 = "90b610a3dbbf6d257b20a079eba3fdf2eed2158f64066a7c6f7227023fd60bc9";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."Keras-Applications"
        self."Keras-Preprocessing"
        self."PyYAML"
        self."h5py"
        self."numpy"
        self."scipy"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/keras-team/keras";
        license = licenses.mit;
        description = "Deep Learning for humans";
      };
    };

    "Keras-Applications" = python.mkDerivation {
      name = "Keras-Applications-1.0.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/4b/93/cad07b0878d11f0b694bea0a212be789b819b30933995ef34ddc482f889e/Keras_Applications-1.0.7.tar.gz";
        sha256 = "60607b2b98868983e5153bf1cc6aa468ba73adc93bc977a90edaa4bc595e69fa";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."h5py"
        self."numpy"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/keras-team/keras-applications";
        license = licenses.mit;
        description = "Reference implementations of popular deep learning models";
      };
    };

    "Keras-Preprocessing" = python.mkDerivation {
      name = "Keras-Preprocessing-1.0.8";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/98/35/8d86f3c39374ed6c9ebbeffc2c824b1fad29b62ac5a862b2d5c2e9770ef1/Keras_Preprocessing-1.0.8.tar.gz";
        sha256 = "6e669aa713727f0bc08f756616f64e0dfa75d822226cfc0dcf33297ab05cef7d";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."Pillow"
        self."numpy"
        self."scipy"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/keras-team/keras-preprocessing";
        license = licenses.mit;
        description = "Easy data preprocessing and data augmentation for deep learning models";
      };
    };

    "Logbook" = python.mkDerivation {
      name = "Logbook-1.4.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f6/83/20fc0270614919cb799f76e32cf143a54c58ce2fa45c19fd38ac2e4f9977/Logbook-1.4.3.tar.gz";
        sha256 = "a5a96792abd8172c80d61b7530e134524f20e2841981038031e602ed5920fef5";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."Cython"
        self."pytest"
        self."pytest-cov"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://logbook.pocoo.org/";
        license = licenses.bsdOriginal;
        description = "A logging replacement for Python";
      };
    };

    "Pillow" = python.mkDerivation {
      name = "Pillow-5.4.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/3c/7e/443be24431324bd34d22dd9d11cc845d995bcd3b500676bcf23142756975/Pillow-5.4.1.tar.gz";
        sha256 = "5233664eadfa342c639b9b9977190d64ad7aca4edc51a966394d7e08e7f38a9f";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://python-pillow.org";
        license = "Standard PIL License";
        description = "Python Imaging Library (Fork)";
      };
    };

    "PyWavelets" = python.mkDerivation {
      name = "PyWavelets-1.0.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b4/42/074c6adcd1586926650d8365bcc3e1ab42f81a68c620c4242aa9297b01d9/PyWavelets-1.0.1.tar.gz";
        sha256 = "3c5cece36d4e17d395be6e9ac6b80ce7b774a1f71c251756c6163e63b6d878dc";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."numpy"
      ];
      propagatedBuildInputs = [
        self."numpy"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/PyWavelets/pywt";
        license = licenses.mit;
        description = "PyWavelets, wavelet transform module";
      };
    };

    "PyYAML" = python.mkDerivation {
      name = "PyYAML-3.13";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz";
        sha256 = "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pyyaml.org/wiki/PyYAML";
        license = licenses.mit;
        description = "YAML parser and emitter for Python";
      };
    };

    "Pygments" = python.mkDerivation {
      name = "Pygments-2.3.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/64/69/413708eaf3a64a6abb8972644e0f20891a55e621c6759e2c3f3891e05d63/Pygments-2.3.1.tar.gz";
        sha256 = "5ffada19f6203563680669ee7f53b64dabbeb100eb51b61996085e99c03b284a";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pygments.org/";
        license = licenses.bsdOriginal;
        description = "Pygments is a syntax highlighting package written in Python.";
      };
    };

    "aioamqp" = python.mkDerivation {
      name = "aioamqp-0.12.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/51/15/11ceb44c67a5fdd8cc19dddc1bef7d824100ea7488382eee3b4c3331f890/aioamqp-0.12.0.tar.gz";
        sha256 = "80897483fddbae0557e5e9917f52bf4508dfe707f8c979285e0165a9a4a1799f";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/polyconseil/aioamqp";
        license = licenses.bsdOriginal;
        description = "AMQP implementation using asyncio";
      };
    };

    "aiohttp" = python.mkDerivation {
      name = "aiohttp-3.5.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/0f/58/c8b83f999da3b13e66249ea32f325be923791c0c10aee6cf16002a3effc1/aiohttp-3.5.4.tar.gz";
        sha256 = "9c4c83f4fa1938377da32bc2d59379025ceeee8e24b89f72fcbccd8ca22dc9bf";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."async-timeout"
        self."attrs"
        self."chardet"
        self."multidict"
        self."yarl"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/aio-libs/aiohttp";
        license = licenses.asl20;
        description = "Async http client/server framework (asyncio)";
      };
    };

    "asn1crypto" = python.mkDerivation {
      name = "asn1crypto-0.24.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz";
        sha256 = "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/wbond/asn1crypto";
        license = licenses.mit;
        description = "Fast ASN.1 parser and serializer with definitions for private keys, public keys, certificates, CRL, OCSP, CMS, PKCS#3, PKCS#7, PKCS#8, PKCS#12, PKCS#5, X.509 and TSP";
      };
    };

    "async-timeout" = python.mkDerivation {
      name = "async-timeout-3.0.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz";
        sha256 = "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/aio-libs/async_timeout/";
        license = licenses.asl20;
        description = "Timeout context manager for asyncio programs";
      };
    };

    "atomicwrites" = python.mkDerivation {
      name = "atomicwrites-1.3.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ec/0f/cd484ac8820fed363b374af30049adc8fd13065720fd4f4c6be8a2309da7/atomicwrites-1.3.0.tar.gz";
        sha256 = "75a9445bac02d8d058d5e1fe689654ba5a6556a1dfd8ce6ec55a0ed79866cfa6";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/untitaker/python-atomicwrites";
        license = licenses.mit;
        description = "Atomic file writes.";
      };
    };

    "attrs" = python.mkDerivation {
      name = "attrs-18.2.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/0f/9e/26b1d194aab960063b266170e53c39f73ea0d0d3f5ce23313e0ec8ee9bdf/attrs-18.2.0.tar.gz";
        sha256 = "10cbf6e27dbce8c30807caf056c8eb50917e0eaafe86347671b57254006c3e69";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.attrs.org/";
        license = licenses.mit;
        description = "Classes Without Boilerplate";
      };
    };

    "backcall" = python.mkDerivation {
      name = "backcall-0.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/84/71/c8ca4f5bb1e08401b916c68003acf0a0655df935d74d93bf3f3364b310e0/backcall-0.1.0.tar.gz";
        sha256 = "38ecd85be2c1e78f77fd91700c76e14667dc21e2713b63876c0eb901196e01e4";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/takluyver/backcall";
        license = licenses.bsdOriginal;
        description = "Specifications for callback functions passed in to an API";
      };
    };

    "boto" = python.mkDerivation {
      name = "boto-2.49.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz";
        sha256 = "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/boto/";
        license = licenses.mit;
        description = "Amazon Web Services Library";
      };
    };

    "boto3" = python.mkDerivation {
      name = "boto3-1.9.86";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d2/ae/a3a6a0176e5e29716d5f5f89572525689f0d3eb031fc3091000af9b4200c/boto3-1.9.86.tar.gz";
        sha256 = "63cd957ba663f5c10ff48ed904575eaa701314f79f18dbc59bd050311cd5f809";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."botocore"
        self."jmespath"
        self."s3transfer"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/boto3";
        license = licenses.asl20;
        description = "The AWS SDK for Python";
      };
    };

    "botocore" = python.mkDerivation {
      name = "botocore-1.12.86";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/8e/b3/b9f7ffa347057fa44c65197864eec6a8a53f5a24f613b1b7b3f2b755cc65/botocore-1.12.86.tar.gz";
        sha256 = "24444e7580f0114c3e9fff5d2032c6f0cfbf88691b1be3ba27c6922507a902ec";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."docutils"
        self."jmespath"
        self."python-dateutil"
        self."urllib3"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/botocore";
        license = licenses.asl20;
        description = "Low-level, data-driven core of boto 3.";
      };
    };

    "bugbug" = python.mkDerivation {
      name = "bugbug-0.0.1";
      src = pkgs.fetchurl {
        url = "https://github.com/marco-c/bugbug/archive/3efb956cffa36a62644f830042f0fcbf812db97a.tar.gz";
        sha256 = "1sn354bqi457824vwg77178h1zw6hdxzb4lix4h9mmnxkvj15ifx";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."Keras"
        self."en-core-web-sm"
        self."gensim"
        self."imbalanced-learn"
        self."libmozdata"
        self."numpy"
        self."pandas"
        self."parsepatch"
        self."python-hglib"
        self."requests"
        self."scikit-learn"
        self."scipy"
        self."shap"
        self."spacy"
        self."tqdm"
        self."xgboost"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "UNKNOWN";
        license = licenses.mpl20;
        description = "ML tools for Mozilla projects";
      };
    };

    "bz2file" = python.mkDerivation {
      name = "bz2file-0.98";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/61/39/122222b5e85cd41c391b68a99ee296584b2a2d1d233e7ee32b4532384f2d/bz2file-0.98.tar.gz";
        sha256 = "64c1f811e31556ba9931953c8ec7b397488726c63e09a4c67004f43bdd28da88";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/nvawda/bz2file";
        license = licenses.asl20;
        description = "Read and write bzip2-compressed files.";
      };
    };

    "cachetools" = python.mkDerivation {
      name = "cachetools-3.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/05/07/c117b9527a0cd5beb7990fcdb7b0abf57e84f2d82eaf130921b43e594df4/cachetools-3.1.0.tar.gz";
        sha256 = "9efcc9fab3b49ab833475702b55edd5ae07af1af7a4c627678980b45e459c460";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tkem/cachetools";
        license = licenses.mit;
        description = "Extensible memoizing collections and decorators";
      };
    };

    "certifi" = python.mkDerivation {
      name = "certifi-2018.11.29";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/55/54/3ce77783acba5979ce16674fc98b1920d00b01d337cfaaf5db22543505ed/certifi-2018.11.29.tar.gz";
        sha256 = "47f9c83ef4c0c621eaef743f133f09fa8a74a9b75f037e8624f83bd1b6626cb7";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://certifi.io/";
        license = licenses.mpl20;
        description = "Python package for providing Mozilla's CA Bundle.";
      };
    };

    "cffi" = python.mkDerivation {
      name = "cffi-1.11.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz";
        sha256 = "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pycparser"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://cffi.readthedocs.org";
        license = licenses.mit;
        description = "Foreign Function Interface for Python calling C code.";
      };
    };

    "chardet" = python.mkDerivation {
      name = "chardet-3.0.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz";
        sha256 = "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/chardet/chardet";
        license = licenses.lgpl3;
        description = "Universal encoding detector for Python 2 and 3";
      };
    };

    "cloudpickle" = python.mkDerivation {
      name = "cloudpickle-0.7.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c8/d8/08e40c7d5e2c7232f71cf1245eed47eae4dabaf1fbf5a76fc7d008011f56/cloudpickle-0.7.0.tar.gz";
        sha256 = "d894ba62b0a04c3ccd482f6bc720dd02d4febcf320f5916c33d258b85d8409b1";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/cloudpipe/cloudpickle";
        license = "BSD 3-Clause License";
        description = "Extended pickling support for Python objects";
      };
    };

    "codecov" = python.mkDerivation {
      name = "codecov-2.0.15";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/77/f2/9790ee0f04eb0571841aff5ba1709c7869e82aa2145a04a3d4770807ff50/codecov-2.0.15.tar.gz";
        sha256 = "8ed8b7c6791010d359baed66f84f061bba5bd41174bf324c31311e8737602788";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."coverage"
        self."requests"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/codecov/codecov-python";
        license = "http://www.apache.org/licenses/LICENSE-2.0";
        description = "Hosted coverage reports for Github, Bitbucket and Gitlab";
      };
    };

    "coverage" = python.mkDerivation {
      name = "coverage-4.5.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/fb/af/ce7b0fe063ee0142786ee53ad6197979491ce0785567b6d8be751d2069e8/coverage-4.5.2.tar.gz";
        sha256 = "ab235d9fe64833f12d1334d29b558aacedfbca2356dfb9691f2d0d38a8a7bfb4";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://bitbucket.org/ned/coveragepy";
        license = licenses.asl20;
        description = "Code coverage measurement for Python";
      };
    };

    "coveralls" = python.mkDerivation {
      name = "coveralls-1.5.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d2/4a/d0966ab522988667a9f23886dcec5cc029f1eb9848843466fbd2bb7a37fb/coveralls-1.5.1.tar.gz";
        sha256 = "ab638e88d38916a6cedbf80a9cd8992d5fa55c77ab755e262e00b36792b7cd6d";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."PyYAML"
        self."coverage"
        self."docopt"
        self."requests"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/coveralls-clients/coveralls-python";
        license = licenses.mit;
        description = "Show coverage stats online via coveralls.io";
      };
    };

    "cryptography" = python.mkDerivation {
      name = "cryptography-2.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/69/ed/5e97b7f54237a9e4e6291b6e52173372b7fa45ca730d36ea90b790c0059a/cryptography-2.5.tar.gz";
        sha256 = "4946b67235b9d2ea7d31307be9d5ad5959d6c4a8f98f900157b47abddf698401";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."asn1crypto"
        self."cffi"
        self."flake8"
        self."idna"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pyca/cryptography";
        license = licenses.bsdOriginal;
        description = "cryptography is a package which provides cryptographic recipes and primitives to Python developers.";
      };
    };

    "cycler" = python.mkDerivation {
      name = "cycler-0.10.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c2/4b/137dea450d6e1e3d474e1d873cd1d4f7d3beed7e0dc973b06e8e10d32488/cycler-0.10.0.tar.gz";
        sha256 = "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/matplotlib/cycler";
        license = licenses.bsdOriginal;
        description = "Composable style cycles";
      };
    };

    "cymem" = python.mkDerivation {
      name = "cymem-2.0.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/8b/dc/0976e04cc46f86e0dd3ee3797ec68057eaafebf31daca9a076dc138b9920/cymem-2.0.2.tar.gz";
        sha256 = "ab88b1534f06df07262d9bc5efb3ba07948cdbe9a363eb9eaa4ad42fae6c7b5e";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/explosion/cymem";
        license = licenses.mit;
        description = "Manage calls to calloc/free through Cython";
      };
    };

    "cytoolz" = python.mkDerivation {
      name = "cytoolz-0.9.0.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/36/f4/9728ba01ccb2f55df9a5af029b48ba0aaca1081bbd7823ea2ee223ba7a42/cytoolz-0.9.0.1.tar.gz";
        sha256 = "84cc06fa40aa310f2df79dd440fc5f84c3e20f01f9f7783fc9c38d0a11ba00e5";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."toolz"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pytoolz/cytoolz";
        license = licenses.bsdOriginal;
        description = "Cython implementation of Toolz: High performance functional utilities";
      };
    };

    "dask" = python.mkDerivation {
      name = "dask-1.1.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/67/56/34f593367b61e4f3be42b871e5fab969b40d43243f74d76d4a59c16be256/dask-1.1.1.tar.gz";
        sha256 = "2e70135d6856805699b52774d8e0cec41beda92bdfc9f9c776962b4bfb34822c";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."cloudpickle"
        self."numpy"
        self."pandas"
        self."toolz"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/dask/dask/";
        license = licenses.bsdOriginal;
        description = "Parallel PyData with Task Scheduling";
      };
    };

    "decorator" = python.mkDerivation {
      name = "decorator-4.3.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c4/26/b48aaa231644bc875bb348e162d156edb18b994da900a10f4493ea995a2f/decorator-4.3.2.tar.gz";
        sha256 = "33cd704aea07b4c28b3eb2c97d288a06918275dac0ecebdaf1bc8a48d98adb9e";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/micheles/decorator";
        license = "new BSD License";
        description = "Better living through Python with decorators";
      };
    };

    "dill" = python.mkDerivation {
      name = "dill-0.2.9";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/fe/42/bfe2e0857bc284cbe6a011d93f2a9ad58a22cb894461b199ae72cfef0f29/dill-0.2.9.tar.gz";
        sha256 = "f6d6046f9f9195206063dd0415dff185ad593d6ee8b0e67f12597c0f4df4986f";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pypi.org/project/dill";
        license = "3-clause BSD";
        description = "serialize all of python";
      };
    };

    "docopt" = python.mkDerivation {
      name = "docopt-0.6.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz";
        sha256 = "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docopt.org";
        license = licenses.mit;
        description = "Pythonic argument parser, that will make you smile";
      };
    };

    "docutils" = python.mkDerivation {
      name = "docutils-0.14";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz";
        sha256 = "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://docutils.sourceforge.net/";
        license = "public domain, Python, 2-Clause BSD, GPL 3 (see COPYING.txt)";
        description = "Docutils -- Python Documentation Utilities";
      };
    };

    "en-core-web-sm" = python.mkDerivation {
      name = "en-core-web-sm-2.0.0";
      src = pkgs.fetchurl {
        url = "https://github.com/explosion/spacy-models/releases/download/en_core_web_sm-2.0.0/en_core_web_sm-2.0.0.tar.gz";
        sha256 = "9d9d231d7c9cbad82178b566fdb25768e3d5098af23ce11e03ec4f432f4a2298";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."spacy"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://explosion.ai";
        license = "CC BY-SA 3.0";
        description = "English multi-task CNN trained on OntoNotes, with GloVe vectors trained on Common Crawl. Assigns word vectors, context-specific token vectors, POS tags, dependency parse and named entities.";
      };
    };

    "entrypoints" = python.mkDerivation {
      name = "entrypoints-0.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz";
        sha256 = "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/takluyver/entrypoints";
        license = "UNKNOWN";
        description = "Discover and load entry points from installed packages.";
      };
    };

    "fancycompleter" = python.mkDerivation {
      name = "fancycompleter-0.8";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/fd/e3/da39a6cfaffe578a01221261ac1d5d99c48d44f6377ff0de3a12dd332cec/fancycompleter-0.8.tar.gz";
        sha256 = "d2522f1f3512371f295379c4c0d1962de06762eb586c199620a2a5d423539b12";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."setuptools-scm"
      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://bitbucket.org/antocuni/fancycompleter";
        license = licenses.bsdOriginal;
        description = "colorful TAB completion for Python prompt";
      };
    };

    "flake8" = python.mkDerivation {
      name = "flake8-3.7.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a2/6f/e81e1ec2396afdd9a8c1cddabd3ce47dc9a31160df782654c9d9979cd9e8/flake8-3.7.5.tar.gz";
        sha256 = "fd9ddf503110bf3d8b1d270e8c673aab29ccb3dd6abf29bae1f54e5116ab4a91";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."entrypoints"
        self."mccabe"
        self."pycodestyle"
        self."pyflakes"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://gitlab.com/pycqa/flake8";
        license = licenses.mit;
        description = "the modular source code checker: pep8, pyflakes and co";
      };
    };

    "flake8-coding" = python.mkDerivation {
      name = "flake8-coding-1.3.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f9/d7/889f7961ed549f15a280fa36edfc9b9016df38cd25cd0a8a7e4edc06efcf/flake8-coding-1.3.1.tar.gz";
        sha256 = "549c2b22c08711feda11795fb49f147a626305b602c547837bab405e7981f844";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."flake8"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tk0miya/flake8-coding";
        license = licenses.asl20;
        description = "Adds coding magic comment checks to flake8";
      };
    };

    "flake8-copyright" = python.mkDerivation {
      name = "flake8-copyright-0.2.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/66/35/3a5712611f8345329582817c71db68f6a1b6f4d500efeaeca1137b241417/flake8-copyright-0.2.2.tar.gz";
        sha256 = "5c3632dd8c586547b25fff4272282005fdbcba56eeb77b7487564aa636b6e533";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/savoirfairelinux/flake8-copyright";
        license = "UNKNOWN";
        description = "Adds copyright checks to flake8";
      };
    };

    "flake8-debugger" = python.mkDerivation {
      name = "flake8-debugger-3.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/39/4b/90548607282483dd15f9ce1f4434d735ae756e16e1faf60621b0f8877fcc/flake8-debugger-3.1.0.tar.gz";
        sha256 = "be4fb88de3ee8f6dd5053a2d347e2c0a2b54bab6733a2280bb20ebd3c4ca1d97";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."pytest-runner"
      ];
      propagatedBuildInputs = [
        self."flake8"
        self."pycodestyle"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jbkahn/flake8-debugger";
        license = licenses.mit;
        description = "ipdb/pdb statement checker plugin for flake8";
      };
    };

    "flake8-isort" = python.mkDerivation {
      name = "flake8-isort-2.6.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/85/fb/f2a33e47cf7520fd391e5f180cae5b8d2977ad7a5ddf897213137fe8a171/flake8-isort-2.6.0.tar.gz";
        sha256 = "3c107c405dd6e3dbdcccb2f84549d76d58a07120cd997a0560fab8b84c305f2a";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."flake8"
        self."isort"
        self."testfixtures"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gforcada/flake8-isort";
        license = "GPL version 2";
        description = "flake8 plugin that integrates isort .";
      };
    };

    "flake8-mypy" = python.mkDerivation {
      name = "flake8-mypy-17.8.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/97/9a/cddd1363d7314bb4eb452089c6fb3092ed9fda9f3350683d1978522a30ec/flake8-mypy-17.8.0.tar.gz";
        sha256 = "47120db63aff631ee1f84bac6fe8e64731dc66da3efc1c51f85e15ade4a3ba18";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."attrs"
        self."flake8"
        self."mypy"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/ambv/flake8-mypy";
        license = licenses.mit;
        description = "A plugin for flake8 integrating mypy.";
      };
    };

    "flake8-quotes" = python.mkDerivation {
      name = "flake8-quotes-1.0.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/83/ff/0461010959158bb7d197691c696f1a85b20f2d3eea7aa23f73a8d07f30f3/flake8-quotes-1.0.0.tar.gz";
        sha256 = "fd9127ad8bbcf3b546fa7871a5266fd8623ce765ebe3d5aa5eabb80c01212b26";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."flake8"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/zheller/flake8-quotes/";
        license = licenses.mit;
        description = "Flake8 lint for quotes.";
      };
    };

    "flit" = python.mkDerivation {
      name = "flit-1.2.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/6a/55/a25505e3b3f5d804d1a0b6a64c582f4a264697c94862ccf71b8a1c62d16d/flit-1.2.1.tar.gz";
        sha256 = "6aefa6ff89a993af7a7af40d3df3d0387d6663df99797981ec41b1431ec6d1e1";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."docutils"
        self."pytoml"
        self."requests"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/takluyver/flit";
        license = "UNKNOWN";
        description = "A simple packaging tool for simple packages.";
      };
    };

    "gensim" = python.mkDerivation {
      name = "gensim-3.7.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/fc/6d/6bf367a5d7b19bd3b7fbcab08c42ce0ae4d102e52eefb3ea1dda1278eb41/gensim-3.7.1.tar.gz";
        sha256 = "ed845ac585f724ae1f40fdb517ed8ade822531f9bbcd1be4a599c2e86aff48a8";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."numpy"
      ];
      propagatedBuildInputs = [
        self."Cython"
        self."numpy"
        self."pytest"
        self."scikit-learn"
        self."scipy"
        self."six"
        self."smart-open"
        self."testfixtures"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://radimrehurek.com/gensim";
        license = "LGPLv2.1";
        description = "Python framework for fast Vector Space Modelling";
      };
    };

    "google-api-python-client" = python.mkDerivation {
      name = "google-api-python-client-1.7.8";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/7a/84/ffde3c95d4162cdc8bae710fecc6873cccb05ac33afc3b2c925c74cc0150/google-api-python-client-1.7.8.tar.gz";
        sha256 = "06907006ed5ce831018f03af3852d739c0b2489cdacfda6971bcc2075c762858";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."google-auth"
        self."google-auth-httplib2"
        self."httplib2"
        self."six"
        self."uritemplate"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/google/google-api-python-client/";
        license = licenses.asl20;
        description = "Google API Client Library for Python";
      };
    };

    "google-auth" = python.mkDerivation {
      name = "google-auth-1.6.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5f/8a/b75ec006bf703c96920ce9ba3e97ac9c6eb48772af689576808fc68ac04f/google-auth-1.6.2.tar.gz";
        sha256 = "e8d64e9bc8cb6f0fc5360c693f86dc9ee6964081ee702e3b5ddc937f99efc950";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."cachetools"
        self."pyasn1-modules"
        self."rsa"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python";
        license = licenses.asl20;
        description = "Google Authentication Library";
      };
    };

    "google-auth-httplib2" = python.mkDerivation {
      name = "google-auth-httplib2-0.0.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e7/32/ac7f30b742276b4911a1439c5291abab1b797ccfd30bc923c5ad67892b13/google-auth-httplib2-0.0.3.tar.gz";
        sha256 = "098fade613c25b4527b2c08fa42d11f3c2037dda8995d86de0745228e965d445";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."google-auth"
        self."httplib2"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GoogleCloudPlatform/google-auth-library-python-httplib2";
        license = licenses.asl20;
        description = "Google Authentication Library: httplib2 transport";
      };
    };

    "h5py" = python.mkDerivation {
      name = "h5py-2.9.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/43/27/a6e7dcb8ae20a4dbf3725321058923fec262b6f7835179d78ccc8d98deec/h5py-2.9.0.tar.gz";
        sha256 = "9d41ca62daf36d6b6515ab8765e4c8c4388ee18e2a665701fef2b41563821002";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."Cython"
        self."numpy"
        self."pkgconfig"
        self."six"
      ];
      propagatedBuildInputs = [
        self."numpy"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.h5py.org";
        license = licenses.bsdOriginal;
        description = "Read and write HDF5 files from Python";
      };
    };

    "httplib2" = python.mkDerivation {
      name = "httplib2-0.12.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ce/ed/803905d670b52fa0edfdd135337e545b4496c2ab3a222f1449b7256eb99f/httplib2-0.12.0.tar.gz";
        sha256 = "f61fb838a94ce3b349aa32c92fd8430f7e3511afdb18bf9640d647e30c90a6d6";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/httplib2/httplib2";
        license = licenses.mit;
        description = "A comprehensive HTTP client library.";
      };
    };

    "icalendar" = python.mkDerivation {
      name = "icalendar-4.0.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/5d/92/647cd84120b8d9c2ac9a03ccff21bb44c267c993b88881a32c1837d250bd/icalendar-4.0.3.tar.gz";
        sha256 = "07c2447a1d44cbb27c90b8c6a5c98e890cc1853c6223e2a52195cddec26c6356";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."python-dateutil"
        self."pytz"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/collective/icalendar";
        license = licenses.bsdOriginal;
        description = "iCalendar parser/generator";
      };
    };

    "idna" = python.mkDerivation {
      name = "idna-2.8";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz";
        sha256 = "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kjd/idna";
        license = licenses.bsdOriginal;
        description = "Internationalized Domain Names in Applications (IDNA)";
      };
    };

    "imbalanced-learn" = python.mkDerivation {
      name = "imbalanced-learn-0.4.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/4f/4d/e260fc004307d6ebc4909ee25e6c918a2399a7fb91975afd95ec48d1c8b4/imbalanced-learn-0.4.3.tar.gz";
        sha256 = "5bd9e86e40ce4001a57426541d7c79b18143cbd181e3330c1a3e5c5c43287083";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."numpy"
        self."scikit-learn"
        self."scipy"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/scikit-learn-contrib/imbalanced-learn";
        license = licenses.mit;
        description = "Toolbox for imbalanced dataset in machine learning.";
      };
    };

    "intreehooks" = python.mkDerivation {
      name = "intreehooks-1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f9/a5/5dacebf93232a847970921af2b020f9f2a8e0064e3a97727cd38efc77ba0/intreehooks-1.0.tar.gz";
        sha256 = "87e600d3b16b97ed219c078681260639e77ef5a17c0e0dbdd5a302f99b4e34e1";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pytoml"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/takluyver/intreehooks";
        license = "UNKNOWN";
        description = "Load a PEP 517 backend from inside the source tree";
      };
    };

    "ipython" = python.mkDerivation {
      name = "ipython-7.2.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/42/bb/0ed1fb1d57d697326f9e9b827d9a74b81dee56031ed7c252bc716195ad7a/ipython-7.2.0.tar.gz";
        sha256 = "6a9496209b76463f1dec126ab928919aaf1f55b38beb9219af3fe202f6bbdd12";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."Pygments"
        self."backcall"
        self."decorator"
        self."jedi"
        self."numpy"
        self."pexpect"
        self."pickleshare"
        self."prompt-toolkit"
        self."requests"
        self."traitlets"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://ipython.org";
        license = licenses.bsdOriginal;
        description = "IPython: Productive Interactive Computing";
      };
    };

    "ipython-genutils" = python.mkDerivation {
      name = "ipython-genutils-0.2.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz";
        sha256 = "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://ipython.org";
        license = licenses.bsdOriginal;
        description = "Vestigial utilities from IPython";
      };
    };

    "isort" = python.mkDerivation {
      name = "isort-4.3.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b1/de/a628d16fdba0d38cafb3d7e34d4830f2c9cb3881384ce5c08c44762e1846/isort-4.3.4.tar.gz";
        sha256 = "b9c40e9750f3d77e6e4d441d8b0266cf555e7cdabdcff33c4fd06366ca761ef8";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/timothycrosley/isort";
        license = licenses.mit;
        description = "A Python utility / library to sort Python imports.";
      };
    };

    "jedi" = python.mkDerivation {
      name = "jedi-0.13.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e4/83/4c05db437252694660c972b5374b35a68a8a0a8cd012dc95e5fd4d7e71b0/jedi-0.13.2.tar.gz";
        sha256 = "571702b5bd167911fe9036e5039ba67f820d6502832285cde8c881ab2b2149fd";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."docopt"
        self."parso"
        self."pytest"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/davidhalter/jedi";
        license = licenses.mit;
        description = "An autocompletion tool for Python that can be used for text editors.";
      };
    };

    "jmespath" = python.mkDerivation {
      name = "jmespath-0.9.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz";
        sha256 = "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jmespath/jmespath.py";
        license = licenses.mit;
        description = "JSON Matching Expressions";
      };
    };

    "kiwisolver" = python.mkDerivation {
      name = "kiwisolver-1.0.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/31/60/494fcce70d60a598c32ee00e71542e52e27c978e5f8219fae0d4ac6e2864/kiwisolver-1.0.1.tar.gz";
        sha256 = "ce3be5d520b4d2c3e5eeb4cd2ef62b9b9ab8ac6b6fedbaa0e39cdb6f50644278";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/nucleic/kiwi";
        license = "UNKNOWN";
        description = "A fast implementation of the Cassowary constraint solver";
      };
    };

    "libmozdata" = python.mkDerivation {
      name = "libmozdata-0.1.48";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a0/fb/3c4e5dd2250539579376de180a88925d408ffd6bdf8f33d5d9adc2db0c63/libmozdata-0.1.48.tar.gz";
        sha256 = "01de4962d3d5ce750ca24dd764571621d60f49689f1ac591e8d4117e0c486056";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."google-api-python-client"
        self."httplib2"
        self."icalendar"
        self."oauth2client"
        self."python-dateutil"
        self."requests"
        self."requests-futures"
        self."six"
        self."whatthepatch"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/mozilla/libmozdata";
        license = licenses.mpl20;
        description = "Library to access and aggregate several Mozilla data sources.";
      };
    };

    "matplotlib" = python.mkDerivation {
      name = "matplotlib-3.0.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/89/0c/653aec68e9cfb775c4fbae8f71011206e5e7fe4d60fcf01ea1a9d3bc957f/matplotlib-3.0.2.tar.gz";
        sha256 = "c94b792af431f6adb6859eb218137acd9a35f4f7442cea57e4a59c54751c36af";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."numpy"
      ];
      propagatedBuildInputs = [
        self."cycler"
        self."kiwisolver"
        self."numpy"
        self."pyparsing"
        self."python-dateutil"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://matplotlib.org";
        license = licenses.bsdOriginal;
        description = "Python plotting package";
      };
    };

    "mccabe" = python.mkDerivation {
      name = "mccabe-0.6.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz";
        sha256 = "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."pytest-runner"
      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pycqa/mccabe";
        license = "Expat license";
        description = "McCabe checker, plugin for flake8";
      };
    };

    "mohawk" = python.mkDerivation {
      name = "mohawk-0.3.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/19/22/10f696548a8d41ad41b92ab6c848c60c669e18c8681c179265ce4d048b03/mohawk-0.3.4.tar.gz";
        sha256 = "e98b331d9fa9ece7b8be26094cbe2d57613ae882133cc755167268a984bc0ab3";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/kumar303/mohawk";
        license = licenses.mpl20;
        description = "Library for Hawk HTTP authorization";
      };
    };

    "more-itertools" = python.mkDerivation {
      name = "more-itertools-5.0.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/dd/26/30fc0d541d9fdf55faf5ba4b0fd68f81d5bd2447579224820ad525934178/more-itertools-5.0.0.tar.gz";
        sha256 = "38a936c0a6d98a38bcc2d03fdaaedaba9f412879461dd2ceff8d37564d6522e4";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/erikrose/more-itertools";
        license = licenses.mit;
        description = "More routines for operating on iterables, beyond itertools";
      };
    };

    "mozdef-client" = python.mkDerivation {
      name = "mozdef-client-1.0.11";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/cd/9b/d783ba277e2120add2709e45db926f8e916c5933df2db9725b7787884ae5/mozdef_client-1.0.11.tar.gz";
        sha256 = "86b8c7065c21ce07d3095b5772f70fa152fe97258cde22311e5db4e34f5be26d";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."boto3"
        self."pytz"
        self."requests-futures"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/gdestuynder/mozdef_client";
        license = "MPL";
        description = "A client library to send messages/events using MozDef";
      };
    };

    "mozilla-cli-common" = python.mkDerivation {
      name = "mozilla-cli-common-1.0.0";
      src = pkgs.lib.cleanSource ./../../../lib/cli_common;
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."Click"
        self."Logbook"
        self."aioamqp"
        self."mozdef-client"
        self."python-dateutil"
        self."python-hglib"
        self."raven"
        self."requests"
        self."structlog"
        self."taskcluster"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/mozilla/release-services";
        license = licenses.mpl20;
        description = "Services behind https://mozilla-releng.net";
      };
    };

    "msgpack" = python.mkDerivation {
      name = "msgpack-0.5.6";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f3/b6/9affbea179c3c03a0eb53515d9ce404809a122f76bee8fc8c6ec9497f51f/msgpack-0.5.6.tar.gz";
        sha256 = "0ee8c8c85aa651be3aa0cd005b5931769eaa658c948ce79428766f1bd46ae2c3";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://msgpack.org/";
        license = licenses.asl20;
        description = "MessagePack (de)serializer.";
      };
    };

    "msgpack-numpy" = python.mkDerivation {
      name = "msgpack-numpy-0.4.3.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a5/7a/01c7c3f14ec4c38b23767b5f19d42db299f74d8fcabce0f735996b2b156d/msgpack-numpy-0.4.3.2.tar.gz";
        sha256 = "0a8256ffcbee7fef50eff89a452e8873089e03d0bf88d83af87023ac71fdcf68";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."msgpack"
        self."numpy"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/lebedov/msgpack-numpy";
        license = licenses.bsdOriginal;
        description = "Numpy data serialization using msgpack";
      };
    };

    "multidict" = python.mkDerivation {
      name = "multidict-4.5.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/7f/8f/b3c8c5b062309e854ce5b726fc101195fbaa881d306ffa5c2ba19efa3af2/multidict-4.5.2.tar.gz";
        sha256 = "024b8129695a952ebd93373e45b5d341dbb87c17ce49637b34000093f243dd4f";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/aio-libs/multidict";
        license = licenses.asl20;
        description = "multidict implementation";
      };
    };

    "murmurhash" = python.mkDerivation {
      name = "murmurhash-1.0.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e3/9d/70bcac78cf411af9e07d5e62b8fd9998c8b42519fbb8b08973bed35c982c/murmurhash-1.0.1.tar.gz";
        sha256 = "38e91cd5ae5192b8f63cfe756cc784bf0cd44f64a15e496ba0a6fddda3f48b0b";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/explosion/murmurhash";
        license = licenses.mit;
        description = "Cython bindings for MurmurHash2";
      };
    };

    "mypy" = python.mkDerivation {
      name = "mypy-0.660";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a4/f6/032e015285905243cff94625367c7a20ba0acbae8e802b740c8a876b2f39/mypy-0.660.tar.gz";
        sha256 = "986a7f97808a865405c5fd98fae5ebfa963c31520a56c783df159e9a81e41b3e";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."mypy-extensions"
        self."typed-ast"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.mypy-lang.org/";
        license = licenses.mit;
        description = "Optional static typing for Python";
      };
    };

    "mypy-extensions" = python.mkDerivation {
      name = "mypy-extensions-0.4.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c2/92/3cc05d1206237d54db7b2565a58080a909445330b4f90a6436302a49f0f8/mypy_extensions-0.4.1.tar.gz";
        sha256 = "37e0e956f41369209a3d5f34580150bcacfabaa57b33a15c0b25f4b5725e0812";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.mypy-lang.org/";
        license = licenses.mit;
        description = "Experimental type system extensions for programs checked with the mypy typechecker.";
      };
    };

    "networkx" = python.mkDerivation {
      name = "networkx-2.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f3/f4/7e20ef40b118478191cec0b58c3192f822cace858c19505c7670961b76b2/networkx-2.2.zip";
        sha256 = "45e56f7ab6fe81652fb4bc9f44faddb0e9025f469f602df14e3b2551c2ea5c8b";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."PyYAML"
        self."decorator"
        self."matplotlib"
        self."numpy"
        self."pandas"
        self."scipy"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://networkx.github.io/";
        license = licenses.bsdOriginal;
        description = "Python package for creating and manipulating graphs and networks";
      };
    };

    "numpy" = python.mkDerivation {
      name = "numpy-1.16.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/2b/26/07472b0de91851b6656cbc86e2f0d5d3a3128e7580f23295ef58b6862d6c/numpy-1.16.1.zip";
        sha256 = "31d3fe5b673e99d33d70cfee2ea8fe8dccd60f265c3ed990873a88647e3dd288";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.numpy.org";
        license = licenses.bsdOriginal;
        description = "NumPy is the fundamental package for array computing with Python.";
      };
    };

    "oauth2client" = python.mkDerivation {
      name = "oauth2client-4.1.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz";
        sha256 = "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."httplib2"
        self."pyasn1"
        self."pyasn1-modules"
        self."rsa"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/google/oauth2client/";
        license = licenses.asl20;
        description = "OAuth 2.0 client library";
      };
    };

    "pandas" = python.mkDerivation {
      name = "pandas-0.24.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/81/fd/b1f17f7dc914047cd1df9d6813b944ee446973baafe8106e4458bfb68884/pandas-0.24.1.tar.gz";
        sha256 = "435821cb2501eabbcee7e83614bd710940dc0cf28b5afbc4bdb816c31cec71af";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."numpy"
      ];
      propagatedBuildInputs = [
        self."numpy"
        self."python-dateutil"
        self."pytz"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pandas.pydata.org";
        license = licenses.bsdOriginal;
        description = "Powerful data structures for data analysis, time series, and statistics";
      };
    };

    "parsepatch" = python.mkDerivation {
      name = "parsepatch-0.1.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d2/73/9eaedc53bdf9c5690d22812aaadce997634d74d2fbaf79f91b8f209be121/parsepatch-0.1.3.tar.gz";
        sha256 = "1f08654d3c737c7f43e5b5a03b078d0bb206684ba106df714db89f8c87fbd58a";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."requests"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/mozilla/parsepatch";
        license = "MPL";
        description = "Library to parse patches in an efficient manner";
      };
    };

    "parso" = python.mkDerivation {
      name = "parso-0.3.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/22/50/fa4ffb9b7e0b52f0bea19e5fcc9759eda369efa43a4e4a534a5cf9a00e71/parso-0.3.2.tar.gz";
        sha256 = "4b8f9ed80c3a4a3191aa3261505d868aa552dd25649cb13a7d73b6b7315edf2d";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."docopt"
        self."pytest"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/davidhalter/parso";
        license = licenses.mit;
        description = "A Python Parser";
      };
    };

    "pdbpp" = python.mkDerivation {
      name = "pdbpp-0.9.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/cc/23/b398cf535b44fcc5ce278581a78cf7e0e1b6cefaf5b1acbd842293803bdb/pdbpp-0.9.5.tar.gz";
        sha256 = "57eaea444394056c62a28d02280766b8ef3d09077dc194e25079fe49b92912c0";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."setuptools-scm"
      ];
      propagatedBuildInputs = [
        self."Pygments"
        self."fancycompleter"
        self."wmctrl"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/antocuni/pdb";
        license = licenses.bsdOriginal;
        description = "pdb++, a drop-in replacement for pdb";
      };
    };

    "pexpect" = python.mkDerivation {
      name = "pexpect-4.6.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/89/43/07d07654ee3e25235d8cea4164cdee0ec39d1fda8e9203156ebe403ffda4/pexpect-4.6.0.tar.gz";
        sha256 = "2a8e88259839571d1251d278476f3eec5db26deb73a70be5ed5dc5435e418aba";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."ptyprocess"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pexpect.readthedocs.io/";
        license = "ISC license";
        description = "Pexpect allows easy control of interactive console applications.";
      };
    };

    "pickleshare" = python.mkDerivation {
      name = "pickleshare-0.7.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8/pickleshare-0.7.5.tar.gz";
        sha256 = "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pickleshare/pickleshare";
        license = licenses.mit;
        description = "Tiny 'shelve'-like database with concurrency support";
      };
    };

    "pkgconfig" = python.mkDerivation {
      name = "pkgconfig-1.4.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/17/b7/b6e2b5798eeadb6bfbebf6c332c8989463166769815f74d6e87ed9951f61/pkgconfig-1.4.0.tar.gz";
        sha256 = "048c3b457da7b6f686b647ab10bf09e2250e4c50acfe6f215398a8b5e6fcdb52";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/matze/pkgconfig";
        license = licenses.mit;
        description = "Interface Python with pkg-config";
      };
    };

    "plac" = python.mkDerivation {
      name = "plac-0.9.6";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/6c/9b/9e9d461a646d1c874043e105e46cc458c16e5f76f2119c8e670ff5a8db97/plac-0.9.6.tar.gz";
        sha256 = "ba3f719a018175f0a15a6b04e6cc79c25fd563d348aacd320c3644d2a9baf89b";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/micheles/plac";
        license = licenses.bsdOriginal;
        description = "The smartest command line arguments parser in the world";
      };
    };

    "pluggy" = python.mkDerivation {
      name = "pluggy-0.8.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/38/e1/83b10c17688af7b2998fa5342fec58ecbd2a5a7499f31e606ae6640b71ac/pluggy-0.8.1.tar.gz";
        sha256 = "8ddc32f03971bfdf900a81961a48ccf2fb677cf7715108f85295c67405798616";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pytest-dev/pluggy";
        license = "MIT license";
        description = "plugin and hook calling mechanisms for python";
      };
    };

    "preshed" = python.mkDerivation {
      name = "preshed-2.0.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/0b/14/c9aa735cb9c131545fc9e23031baccb87041ac9215b3d75f99e3cf18f6a3/preshed-2.0.1.tar.gz";
        sha256 = "dae01c74313965c487e0ec839e5f28d0c7df9bfd1d978aa5bada3f72ff20a9e5";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."cymem"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/explosion/preshed";
        license = licenses.mit;
        description = "Cython hash table that trusts the keys are pre-hashed";
      };
    };

    "prompt-toolkit" = python.mkDerivation {
      name = "prompt-toolkit-2.0.8";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/0d/f7/571edf48b2e11678fa21245369678815a965bac1d96e09fa60fe365ff79d/prompt_toolkit-2.0.8.tar.gz";
        sha256 = "c6655a12e9b08edb8cf5aeab4815fd1e1bdea4ad73d3bbf269cf2e0c4eb75d5e";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
        self."wcwidth"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jonathanslenders/python-prompt-toolkit";
        license = "BSD-3-Clause";
        description = "Library for building powerful interactive command lines in Python";
      };
    };

    "ptyprocess" = python.mkDerivation {
      name = "ptyprocess-0.6.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/7d/2d/e4b8733cf79b7309d84c9081a4ab558c89d8c89da5961bf4ddb050ca1ce0/ptyprocess-0.6.0.tar.gz";
        sha256 = "923f299cc5ad920c68f2bc0bc98b75b9f838b93b599941a6b63ddbc2476394c0";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pexpect/ptyprocess";
        license = "UNKNOWN";
        description = "Run a subprocess in a pseudo terminal";
      };
    };

    "py" = python.mkDerivation {
      name = "py-1.7.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c7/fa/eb6dd513d9eb13436e110aaeef9a1703437a8efa466ce6bb2ff1d9217ac7/py-1.7.0.tar.gz";
        sha256 = "bf92637198836372b520efcba9e020c330123be8ce527e535d185ed4b6f45694";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."setuptools-scm"
      ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://py.readthedocs.io/";
        license = "MIT license";
        description = "library with cross-python path, ini-parsing, io, code, log facilities";
      };
    };

    "pyOpenSSL" = python.mkDerivation {
      name = "pyOpenSSL-19.0.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/40/d0/8efd61531f338a89b4efa48fcf1972d870d2b67a7aea9dcf70783c8464dc/pyOpenSSL-19.0.0.tar.gz";
        sha256 = "aeca66338f6de19d1aa46ed634c3b9ae519a64b458f8468aec688e7e3c20f200";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."cryptography"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pyopenssl.org/";
        license = licenses.asl20;
        description = "Python wrapper module around the OpenSSL library";
      };
    };

    "pyasn1" = python.mkDerivation {
      name = "pyasn1-0.4.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/46/60/b7e32f6ff481b8a1f6c8f02b0fd9b693d1c92ddd2efb038ec050d99a7245/pyasn1-0.4.5.tar.gz";
        sha256 = "da2420fe13a9452d8ae97a0e478adde1dee153b11ba832a95b223a2ba01c10f7";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1";
        license = licenses.bsdOriginal;
        description = "ASN.1 types and codecs";
      };
    };

    "pyasn1-modules" = python.mkDerivation {
      name = "pyasn1-modules-0.2.4";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/bd/a5/ef7bf693e8a8f015386c9167483199f54f8a8ec01d1c737e05524f16e792/pyasn1-modules-0.2.4.tar.gz";
        sha256 = "a52090e8c5841ebbf08ae455146792d9ef3e8445b21055d3a3b7ed9c712b7c7c";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pyasn1"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/etingof/pyasn1-modules";
        license = licenses.bsdOriginal;
        description = "A collection of ASN.1-based protocols modules.";
      };
    };

    "pycodestyle" = python.mkDerivation {
      name = "pycodestyle-2.5.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/1c/d1/41294da5915f4cae7f4b388cea6c2cd0d6cd53039788635f6875dfe8c72f/pycodestyle-2.5.0.tar.gz";
        sha256 = "e40a936c9a450ad81df37f549d676d127b1b66000a6c500caa2b085bc0ca976c";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://pycodestyle.readthedocs.io/";
        license = "Expat license";
        description = "Python style guide checker";
      };
    };

    "pycparser" = python.mkDerivation {
      name = "pycparser-2.19";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz";
        sha256 = "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/eliben/pycparser";
        license = licenses.bsdOriginal;
        description = "C parser in Python";
      };
    };

    "pyflakes" = python.mkDerivation {
      name = "pyflakes-2.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/48/6d/7bfd617b21292397e10e24af4cf42947a359b0c425b66f194cf5d14b1444/pyflakes-2.1.0.tar.gz";
        sha256 = "5e8c00e30c464c99e0b501dc160b13a14af7f27d4dffb529c556e30a159e231d";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/PyCQA/pyflakes";
        license = licenses.mit;
        description = "passive checker of Python programs";
      };
    };

    "pyparsing" = python.mkDerivation {
      name = "pyparsing-2.3.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b9/b8/6b32b3e84014148dcd60dd05795e35c2e7f4b72f918616c61fdce83d27fc/pyparsing-2.3.1.tar.gz";
        sha256 = "66c9268862641abcac4a96ba74506e594c884e3f57690a696d21ad8210ed667a";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pyparsing/pyparsing/";
        license = licenses.mit;
        description = "Python parsing module";
      };
    };

    "pytest" = python.mkDerivation {
      name = "pytest-4.2.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/41/f8/507d1f6121293a0392f5d0850c138d9c7dac6d22f575734078da2d0f447c/pytest-4.2.0.tar.gz";
        sha256 = "65aeaa77ae87c7fc95de56285282546cfa9c886dc8e5dc78313db1c25e21bc07";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."atomicwrites"
        self."attrs"
        self."more-itertools"
        self."pluggy"
        self."py"
        self."requests"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://docs.pytest.org/en/latest/";
        license = "MIT license";
        description = "pytest: simple powerful testing with Python";
      };
    };

    "pytest-cov" = python.mkDerivation {
      name = "pytest-cov-2.6.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/54/16/4229c5514d12b25c3555ca775c7c3cade9a63da99b52fd5fc45962fa3d29/pytest-cov-2.6.1.tar.gz";
        sha256 = "0ab664b25c6aa9716cbf203b17ddb301932383046082c081b9848a0edf5add33";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."coverage"
        self."pytest"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pytest-dev/pytest-cov";
        license = licenses.mit;
        description = "Pytest plugin for measuring coverage.";
      };
    };

    "pytest-runner" = python.mkDerivation {
      name = "pytest-runner-4.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/9e/b7/fe6e8f87f9a756fd06722216f1b6698ccba4d269eac6329d9f0c441d0f93/pytest-runner-4.2.tar.gz";
        sha256 = "d23f117be39919f00dd91bffeb4f15e031ec797501b717a245e377aee0f577be";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."setuptools-scm"
      ];
      propagatedBuildInputs = [
        self."pytest"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pytest-dev/pytest-runner";
        license = "UNKNOWN";
        description = "Invoke py.test as distutils command with dependency resolution";
      };
    };

    "python-dateutil" = python.mkDerivation {
      name = "python-dateutil-2.6.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz";
        sha256 = "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://dateutil.readthedocs.io";
        license = "Simplified BSD";
        description = "Extensions to the standard Python datetime module";
      };
    };

    "python-hglib" = python.mkDerivation {
      name = "python-hglib-2.6.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/f9/39/4d8fa780f71347c3e25c6192f87e13a0265f44b9b8d0a36de550bf39e172/python-hglib-2.6.1.tar.gz";
        sha256 = "7c1fa0cb4d332dd6ec8409b04787ceba4623e97fb378656f7cab0b996c6ca3b2";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.mercurial-scm.org/wiki/PythonHglibs";
        license = licenses.mit;
        description = "Mercurial Python library";
      };
    };

    "pytoml" = python.mkDerivation {
      name = "pytoml-0.1.20";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/35/35/da1123673c54b6d701453fcd20f751d6a1fae43339b3993ae458875576e4/pytoml-0.1.20.tar.gz";
        sha256 = "ca2d0cb127c938b8b76a9a0d0f855cf930c1d50cc3a0af6d3595b566519a1013";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/avakar/pytoml";
        license = licenses.mit;
        description = "A parser for TOML-0.4.0";
      };
    };

    "pytz" = python.mkDerivation {
      name = "pytz-2018.9";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/af/be/6c59e30e208a5f28da85751b93ec7b97e4612268bb054d0dff396e758a90/pytz-2018.9.tar.gz";
        sha256 = "d5f05e487007e29e03409f9398d074e158d920d36eb82eaf66fb1136b0c5374c";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://pythonhosted.org/pytz";
        license = licenses.mit;
        description = "World timezone definitions, modern and historical";
      };
    };

    "raven" = python.mkDerivation {
      name = "raven-6.10.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/79/57/b74a86d74f96b224a477316d418389af9738ba7a63c829477e7a86dd6f47/raven-6.10.0.tar.gz";
        sha256 = "3fa6de6efa2493a7c827472e984ce9b020797d0da16f1db67197bcc23c8fae54";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/getsentry/raven-python";
        license = licenses.bsdOriginal;
        description = "Raven is a client for Sentry (https://getsentry.com)";
      };
    };

    "regex" = python.mkDerivation {
      name = "regex-2018.1.10";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/76/f4/7146c3812f96fcaaf2d06ff6862582302626a59011ccb6f2833bb38d80f7/regex-2018.01.10.tar.gz";
        sha256 = "139678fc013b75e486e580c39b4c52d085ed7362e400960f8be1711a414f16b5";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://bitbucket.org/mrabarnett/mrab-regex";
        license = licenses.psfl;
        description = "Alternative regular expression module, to replace re.";
      };
    };

    "requests" = python.mkDerivation {
      name = "requests-2.21.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/52/2c/514e4ac25da2b08ca5a464c50463682126385c4272c18193876e91f4bc38/requests-2.21.0.tar.gz";
        sha256 = "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."certifi"
        self."chardet"
        self."cryptography"
        self."idna"
        self."pyOpenSSL"
        self."urllib3"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://python-requests.org";
        license = licenses.asl20;
        description = "Python HTTP for Humans.";
      };
    };

    "requests-futures" = python.mkDerivation {
      name = "requests-futures-0.9.9";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e5/6b/c29ba0ce8d7d981c8099550148755846476c551f9e413801c0981f63ea91/requests-futures-0.9.9.tar.gz";
        sha256 = "200729e932ec1f6d6e58101a8d2b144d48c9695f0585bc1dcf37139190f699a1";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."requests"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/ross/requests-futures";
        license = "Apache License v2";
        description = "Asynchronous Python HTTP for Humans.";
      };
    };

    "responses" = python.mkDerivation {
      name = "responses-0.10.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/c9/3b/bea0bfc243072a3d910befae4d1fb585276260abcac2a62109e01064c551/responses-0.10.5.tar.gz";
        sha256 = "c85882d2dc608ce6b5713a4e1534120f4a0dc6ec79d1366570d2b0c909a50c87";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."requests"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/getsentry/responses";
        license = licenses.asl20;
        description = "A utility library for mocking out the `requests` Python library.";
      };
    };

    "rsa" = python.mkDerivation {
      name = "rsa-4.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/cb/d0/8f99b91432a60ca4b1cd478fd0bdf28c1901c58e3a9f14f4ba3dba86b57f/rsa-4.0.tar.gz";
        sha256 = "1a836406405730121ae9823e19c6e806c62bbad73f890574fff50efa4122c487";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."pyasn1"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://stuvel.eu/rsa";
        license = "ASL 2";
        description = "Pure-Python RSA implementation";
      };
    };

    "s3transfer" = python.mkDerivation {
      name = "s3transfer-0.1.13";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/9a/66/c6a5ae4dbbaf253bd662921b805e4972451a6d214d0dc9fb3300cb642320/s3transfer-0.1.13.tar.gz";
        sha256 = "90dc18e028989c609146e241ea153250be451e05ecc0c2832565231dacdf59c1";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."botocore"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/boto/s3transfer";
        license = licenses.asl20;
        description = "An Amazon S3 Transfer Manager";
      };
    };

    "scikit-image" = python.mkDerivation {
      name = "scikit-image-0.14.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/7f/bd/74ed9add17c3c7529c18693c17846753649c6cf2e674e7482fbf85d636cb/scikit-image-0.14.2.tar.gz";
        sha256 = "1afd0b84eefd77afd1071c5c1c402553d67be2d7db8950b32d6f773f25850c1f";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."Pillow"
        self."PyWavelets"
        self."cloudpickle"
        self."dask"
        self."matplotlib"
        self."networkx"
        self."scipy"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://scikit-image.org";
        license = "Modified BSD";
        description = "Image processing routines for SciPy";
      };
    };

    "scikit-learn" = python.mkDerivation {
      name = "scikit-learn-0.20.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/49/0e/8312ac2d7f38537361b943c8cde4b16dadcc9389760bb855323b67bac091/scikit-learn-0.20.2.tar.gz";
        sha256 = "bc5bc7c7ee2572a1edcb51698a6caf11fae554194aaab9a38105d9ec419f29e6";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."numpy"
        self."scipy"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://scikit-learn.org";
        license = "new BSD";
        description = "A set of python modules for machine learning and data mining";
      };
    };

    "scipy" = python.mkDerivation {
      name = "scipy-1.2.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ea/c8/c296904f2c852c5c129962e6ca4ba467116b08cd5b54b7180b2e77fe06b2/scipy-1.2.0.tar.gz";
        sha256 = "51a2424c8ed80e60bdb9a896806e7adaf24a58253b326fbad10f80a6d06f2214";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."numpy"
      ];
      propagatedBuildInputs = [
        self."numpy"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.scipy.org";
        license = licenses.bsdOriginal;
        description = "SciPy: Scientific Library for Python";
      };
    };

    "setuptools-scm" = python.mkDerivation {
      name = "setuptools-scm-3.2.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/54/85/514ba3ca2a022bddd68819f187ae826986051d130ec5b972076e4f58a9f3/setuptools_scm-3.2.0.tar.gz";
        sha256 = "52ab47715fa0fc7d8e6cd15168d1a69ba995feb1505131c3e814eb7087b57358";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/pypa/setuptools_scm/";
        license = licenses.mit;
        description = "the blessed package to manage your versions by scm tags";
      };
    };

    "shap" = python.mkDerivation {
      name = "shap-0.28.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/18/16/ef445c7fe3ecfc80b7d20e64a9f7239d11fffa7dd2f3c046061b360a5786/shap-0.28.3.tar.gz";
        sha256 = "2da76975664c4ef28583a2d64caf222e16b801e5455ff1de365e820f2f4ba9d9";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [
        self."numpy"
      ];
      propagatedBuildInputs = [
        self."ipython"
        self."matplotlib"
        self."numpy"
        self."pandas"
        self."scikit-image"
        self."scikit-learn"
        self."scipy"
        self."tqdm"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/slundberg/shap";
        license = licenses.mit;
        description = "A unified approach to explain the output of any machine learning model.";
      };
    };

    "six" = python.mkDerivation {
      name = "six-1.12.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz";
        sha256 = "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/benjaminp/six";
        license = licenses.mit;
        description = "Python 2 and 3 compatibility utilities";
      };
    };

    "slugid" = python.mkDerivation {
      name = "slugid-1.0.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/dd/96/b05c6d357f8d6932bea2b360537360517d1154b82cc71b8eccb70b28bdde/slugid-1.0.7.tar.gz";
        sha256 = "6dab3c7eef0bb423fb54cb7752e0f466ddd0ee495b78b763be60e8a27f69e779";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://taskcluster.github.io/slugid.py";
        license = licenses.mpl20;
        description = "Base64 encoded uuid v4 slugs";
      };
    };

    "smart-open" = python.mkDerivation {
      name = "smart-open-1.8.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/ff/c8/de7dcf34d4b5f2ae94fe1055e0d6418fb97a63c9dc3428edd264704983a2/smart_open-1.8.0.tar.gz";
        sha256 = "a52206bb69c38c5f08709ec2ee5704b0f86fc0a770935b5dad9b5841bfd5f502";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."boto"
        self."boto3"
        self."bz2file"
        self."requests"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/piskvorky/smart_open";
        license = licenses.mit;
        description = "Utils for streaming large files (S3, HDFS, gzip, bz2...)";
      };
    };

    "spacy" = python.mkDerivation {
      name = "spacy-2.0.18";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/67/5e/63283836960c97283ad20ae58ef62767e232fc351564a22a85df598fd794/spacy-2.0.18.tar.gz";
        sha256 = "123f3b70afa16516ffe458cd8718793e4aab8ab10085a9d0dc121076746dcb57";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."cymem"
        self."dill"
        self."murmurhash"
        self."numpy"
        self."plac"
        self."preshed"
        self."regex"
        self."requests"
        self."thinc"
        self."ujson"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://spacy.io";
        license = licenses.mit;
        description = "Industrial-strength Natural Language Processing (NLP) with Python and Cython";
      };
    };

    "structlog" = python.mkDerivation {
      name = "structlog-19.1.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/e7/e8/988ab8398bd0a445ba2093702caaebd394a303e534f6dddea733a2aada77/structlog-19.1.0.tar.gz";
        sha256 = "5feae03167620824d3ae3e8915ea8589fc28d1ad6f3edf3cc90ed7c7cb33fab5";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://www.structlog.org/";
        license = licenses.mit;
        description = "Structured Logging for Python";
      };
    };

    "taskcluster" = python.mkDerivation {
      name = "taskcluster-6.0.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/06/6a/66bf42549bb69618159b0515c3001b9b8c21bbb5b28f16fcb14cfeef3318/taskcluster-6.0.0.tar.gz";
        sha256 = "48ecd4898c7928deddfb34cb1cfe2b2505c68416e6c503f8a7f3dd0572425e96";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."aiohttp"
        self."async-timeout"
        self."mohawk"
        self."requests"
        self."six"
        self."slugid"
        self."taskcluster-urls"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/taskcluster/taskcluster-client.py";
        license = "UNKNOWN";
        description = "Python client for Taskcluster";
      };
    };

    "taskcluster-urls" = python.mkDerivation {
      name = "taskcluster-urls-11.0.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/69/c1/1f0efd104c7bd6dbb42a7d0c7f1f5f4be05c108e873add8f466e6de9f387/taskcluster-urls-11.0.0.tar.gz";
        sha256 = "18dcaa9c2412d34ff6c78faca33f0dd8f2384e3f00a98d5832c62d6d664741f0";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/taskcluster/taskcluster-lib-urls";
        license = licenses.mpl20;
        description = "Standardized url generator for taskcluster resources.";
      };
    };

    "testfixtures" = python.mkDerivation {
      name = "testfixtures-6.5.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d3/06/52f46d4e05c5d923e384976d057ca14a0d90c561cd150bebe7e04a9ffe15/testfixtures-6.5.0.tar.gz";
        sha256 = "cbd0f095d178de578709bcf4cc6eea896964635d2b41386d1cc7583674809b0e";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/Simplistix/testfixtures";
        license = licenses.mit;
        description = "A collection of helpers and mock objects for unit tests and doc tests.";
      };
    };

    "thinc" = python.mkDerivation {
      name = "thinc-6.12.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/d8/1e/fb93b55dce0e7b0f7184cfa34712302cd0a4ec87c99c8cfb908200b6f49f/thinc-6.12.1.tar.gz";
        sha256 = "90c59454efd7b7a54e68bdc129f411bb27661080b9eba2e2b07e68d6c74277ce";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."cymem"
        self."cytoolz"
        self."dill"
        self."msgpack"
        self."msgpack-numpy"
        self."murmurhash"
        self."numpy"
        self."plac"
        self."preshed"
        self."six"
        self."tqdm"
        self."wrapt"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/explosion/thinc";
        license = licenses.mit;
        description = "Practical Machine Learning for NLP";
      };
    };

    "toolz" = python.mkDerivation {
      name = "toolz-0.9.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/14/d0/a73c15bbeda3d2e7b381a36afb0d9cd770a9f4adc5d1532691013ba881db/toolz-0.9.0.tar.gz";
        sha256 = "929f0a7ea7f61c178bd951bdae93920515d3fbdbafc8e6caf82d752b9b3b31c9";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://github.com/pytoolz/toolz/";
        license = licenses.bsdOriginal;
        description = "List processing tools and functional utilities";
      };
    };

    "tqdm" = python.mkDerivation {
      name = "tqdm-4.30.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/df/85/1b4a823ee751ae69d028f2b65f5127b03218dfab3289b6d720578fb724f2/tqdm-4.30.0.tar.gz";
        sha256 = "dd60ea2567baa013c625153ce41fd274209c69a5814513e1d635f20e5cd61b97";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/tqdm/tqdm";
        license = "MPLv2.0, MIT Licences";
        description = "Fast, Extensible Progress Meter";
      };
    };

    "traitlets" = python.mkDerivation {
      name = "traitlets-4.3.2";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a5/98/7f5ef2fe9e9e071813aaf9cb91d1a732e0a68b6c44a32b38cb8e14c3f069/traitlets-4.3.2.tar.gz";
        sha256 = "9c4bd2d267b7153df9152698efb1050a5d84982d3384a37b2c1f7723ba3e7835";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."decorator"
        self."ipython-genutils"
        self."six"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://ipython.org";
        license = licenses.bsdOriginal;
        description = "Traitlets Python config system";
      };
    };

    "typed-ast" = python.mkDerivation {
      name = "typed-ast-1.2.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/00/be/c3769a5d6a179c42eba04186dc7efeb165edf92f7b1582ccfe81cb17d7f9/typed-ast-1.2.0.tar.gz";
        sha256 = "b4726339a4c180a8b6ad9d8b50d2b6dc247e1b79b38fe2290549c98e82e4fd15";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/python/typed_ast";
        license = licenses.asl20;
        description = "a fork of Python 2 and 3 ast modules with type comment support";
      };
    };

    "ujson" = python.mkDerivation {
      name = "ujson-1.35";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/16/c4/79f3409bc710559015464e5f49b9879430d8f87498ecdc335899732e5377/ujson-1.35.tar.gz";
        sha256 = "f66073e5506e91d204ab0c614a148d5aa938bdbf104751be66f8ad7a222f5f86";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://www.esn.me";
        license = licenses.bsdOriginal;
        description = "Ultra fast JSON encoder and decoder for Python";
      };
    };

    "uritemplate" = python.mkDerivation {
      name = "uritemplate-3.0.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/cd/db/f7b98cdc3f81513fb25d3cbe2501d621882ee81150b745cdd1363278c10a/uritemplate-3.0.0.tar.gz";
        sha256 = "c02643cebe23fc8adb5e6becffe201185bf06c40bda5c0b4028a93f1527d011d";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://uritemplate.readthedocs.org";
        license = "BSD 3-Clause License or Apache License, Version 2.0";
        description = "URI templates";
      };
    };

    "urllib3" = python.mkDerivation {
      name = "urllib3-1.24.1";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz";
        sha256 = "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."certifi"
        self."cryptography"
        self."idna"
        self."pyOpenSSL"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://urllib3.readthedocs.io/";
        license = licenses.mit;
        description = "HTTP library with thread-safe connection pooling, file post, and more.";
      };
    };

    "wcwidth" = python.mkDerivation {
      name = "wcwidth-0.1.7";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz";
        sha256 = "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/jquast/wcwidth";
        license = licenses.mit;
        description = "Measures number of Terminal column cells of wide-character codes";
      };
    };

    "whatthepatch" = python.mkDerivation {
      name = "whatthepatch-0.0.5";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/64/1e/7a63cba8a0d70245b9ab1c03694dabe36476fa65ee546e6dff6c8660434c/whatthepatch-0.0.5.tar.gz";
        sha256 = "494a2ec6c05b80f9ed1bd773f5ac9411298e1af6f0385f179840b5d60d001aa6";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/cscorley/whatthepatch";
        license = licenses.mit;
        description = "A patch parsing library.";
      };
    };

    "wmctrl" = python.mkDerivation {
      name = "wmctrl-0.3";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/01/c6/001aefbde5782d6f359af0a8782990c3f4e751e29518fbd59dc8dfc58b18/wmctrl-0.3.tar.gz";
        sha256 = "d806f65ac1554366b6e31d29d7be2e8893996c0acbb2824bbf2b1f49cf628a13";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "http://bitbucket.org/antocuni/wmctrl";
        license = licenses.bsdOriginal;
        description = "A tool to programmatically control windows inside X";
      };
    };

    "wrapt" = python.mkDerivation {
      name = "wrapt-1.10.11";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/a0/47/66897906448185fcb77fc3c2b1bc20ed0ecca81a0f2f88eda3fc5a34fc3d/wrapt-1.10.11.tar.gz";
        sha256 = "d4d560d479f2c21e1b5443bbd15fe7ec4b37fe7e53d335d3b9b0a7b1226fe3c6";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [ ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/GrahamDumpleton/wrapt";
        license = licenses.bsdOriginal;
        description = "Module for decorators, wrappers and monkey patching.";
      };
    };

    "xgboost" = python.mkDerivation {
      name = "xgboost-0.81";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/4f/4c/4969b10939c4557ae46e5569d07c0c7ce772b3d6b9c1401a6ed07059fdee/xgboost-0.81.tar.gz";
        sha256 = "f7c8057610350b0b2f91e1ac7c034f2f03d233919d111759346559e628061e0c";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."numpy"
        self."scipy"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/dmlc/xgboost";
        license = "UNKNOWN";
        description = "XGBoost Python Package";
      };
    };

    "yarl" = python.mkDerivation {
      name = "yarl-1.3.0";
      src = pkgs.fetchurl {
        url = "https://files.pythonhosted.org/packages/fb/84/6d82f6be218c50b547aa29d0315e430cf8a23c52064c92d0a8377d7b7357/yarl-1.3.0.tar.gz";
        sha256 = "024ecdc12bc02b321bc66b41327f930d1c2c543fa9a561b39861da9388ba7aa9";
      };
      doCheck = commonDoCheck;
      checkPhase = "";
      installCheckPhase = "";
      buildInputs = commonBuildInputs ++ [ ];
      propagatedBuildInputs = [
        self."idna"
        self."multidict"
      ];
      meta = with pkgs.stdenv.lib; {
        homepage = "https://github.com/aio-libs/yarl/";
        license = licenses.asl20;
        description = "Yet another URL library";
      };
    };
  };
  localOverridesFile = ./requirements_override.nix;
  localOverrides = import localOverridesFile { inherit pkgs python; };
  commonOverrides = [
        (import ../../../nix/requirements_override.nix { inherit pkgs python ; })
  ];
  paramOverrides = [
    (overrides { inherit pkgs python; })
  ];
  allOverrides =
    (if (builtins.pathExists localOverridesFile)
     then [localOverrides] else [] ) ++ commonOverrides ++ paramOverrides;

in python.withPackages
   (fix' (pkgs.lib.fold
            extends
            generated
            allOverrides
         )
   )
