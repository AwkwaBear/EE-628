#!/bin/bash

# Check if Conda is installed by checking the CONDA_PREFIX environment variable
if [ -z "$CONDA_PREFIX" ]; then
    echo "Conda is not installed. Installing Miniconda..."

    # Download the Miniconda installer script
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh

    # Install Miniconda silently without modifying the .bashrc file
    bash miniconda.sh -b -p $HOME/miniconda

    # Optionally, initialize Conda
    # $HOME/miniconda/bin/conda init bash

    # Clean up the installer script
    rm miniconda.sh

    echo "Miniconda installed."
else
    echo "Conda is already installed at $CONDA_PREFIX."
fi

# clone pdk
git clone https://github.com/IHP-GmbH/IHP-Open-PDK.git

# install openvaf and compile models
wget https://openva.fra1.cdn.digitaloceanspaces.com/openvaf_23_5_0_linux_amd64.tar.gz
tar -xf openvaf_23_5_0_linux_amd64.tar.gz
./openvaf ./IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/openvaf/psp103_nqs.va
cp ./IHP-Open-PDK/ihp-sg13g2/libs.tech/ngspice/openvaf/psp103_nqs.osdi .

# clone ngspice
sudo apt install bison flex libx11-dev libx11-6 libxaw7-dev libreadline6-dev autoconf libtool automake -y
git clone https://git.code.sf.net/p/ngspice/ngspice

# compile ngspice
cd ngspice && ./compile_linux.sh

# Install PyTorch with the cpu-only option
conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 cpuonly -c pytorch

# Check the version of Python and PyTorch
echo "Python version:"
python --version

echo "PyTorch version:"
python -c "import torch; print(torch.__version__)"
python -c "import torch; print('CUDA version (None for CPU only):', torch.version.cuda)"

# Install PyG components with the specified torch version and cpu-only option
pip install torch-scatter -f https://pytorch-geometric.com/whl/torch-1.13.1+cpu.html
pip install torch-sparse -f https://pytorch-geometric.com/whl/torch-1.13.1+cpu.html
pip install torch-cluster -f https://pytorch-geometric.com/whl/torch-1.13.1+cpu.html
pip install torch-spline-conv -f https://pytorch-geometric.com/whl/torch-1.13.1+cpu.html
pip install torch-geometric

# Check the version of PyG
echo "PyG version:"
python -c "import torch_geometric; print(torch_geometric.__version__)"

# Install Gymnasium for the RL environment
pip install gymnasium

# Check Gymnasium version
echo "Gymnasium version:"
python -c "import gymnasium as gym; print(gym.__version__)"

# Install tabulate for showing simulation results
pip install tabulate

# Check tabulate version
echo "Tabulate version:"
python -c "import tabulate; print(tabulate.__version__)"