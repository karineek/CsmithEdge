sudo add-apt-repository universe -y
sudo apt-get update -y
sudo apt autoremove -y
sudo apt install -y rename
sudo apt install -y cmake
sudo apt install -y m4
sudo apt install unzip -y
echo ">> Intalling req. for gfauto"
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.7 -y
sudo apt install python-pip python3-pip -y
python3.7 -m pip install --upgrade --user 'pip>=19.2.3' 'pipenv>=2018.11.26'
