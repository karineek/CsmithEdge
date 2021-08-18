base=$1/CsmithEdge
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
sudo add-apt-repository universe -y
sudo apt-get update -y
sudo apt autoremove -y
## Compilers:
sudo apt install gcc-10 g++-10 -y
sudo apt-get install clang-11 -y

## Csmith Req.
sudo apt install -y rename
sudo apt install -y cmake
sudo apt install -y m4
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y

## gfauto Req.
sudo apt install python3.8 -y
sudo apt install python-pip python3-pip -y
python3.8 -m pip install --upgrade --user 'pip>=19.2.3' 'pipenv>=2018.11.26'
cd $1
git clone https://github.com/google/graphicsfuzz.git
cd graphicsfuzz/gfauto/
rm -f Pipfile.lock
cp $base/gfauto/dev_shell.sh.template .
./dev_shell.sh.template

# Update Frama-c Version
sudo apt remove frama-c -y -f
sudo apt remove frama-c-base -y -f
sudo add-apt-repository ppa:avsm/ppa
sudo apt update
sudo apt-get install ocaml ocaml-native-compilers graphviz \
             libzarith-ocaml-dev libfindlib-ocaml-dev \
             liblablgtksourceview2-ocaml-dev liblablgtk2-gnome-ocaml-dev -y -f
sudo apt remove opam -f -y
sudo apt install opam -f -y
opam --version
opam update
echo ">> Shall be opam 2.0.0 or above for Frama-c"
opam init -y
eval `opam config env`
opam install why3 why3-ide alt-ergo
why3 --version
alt-ergo -version
echo ">> Try to install ocaml"
sudo apt remove ocaml
# environment setup
opam init
eval `opam env`
# install given version of the compiler
opam switch create 4.10.0
eval `opam env`
# check you got what you want
which ocaml
ocaml -version
echo ">> There is a known issue with OCaml 4.05.0 and ocamlfind 1.8.1"
opam install alt-ergo.2.2.0
opam install depext -y
opam depext frama-c -y
#opam install frama-c -y ==> till know bugs with Ocaml are solved
opam install frama-c.22.0 -y
eval $(opam config env)

# Getting Csmith
cd $base
git clone https://github.com/csmith-project/csmith.git temp
cd ./temp ; git checkout d0b585afb1a3de8c11f33c355bbba739dcf1d01a
cd $base ; cp -rf csmith/* temp/ ; cp -rf temp/* csmith/
cd ./csmith
mkdir build
cd build/
cmake ../
make -j$(nproc)
