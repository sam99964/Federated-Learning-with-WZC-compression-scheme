# Federated-Learning-with-WZC-compression-scheme
Please use
Python version 3.6
Matlab version 2018
------------------------------------------------------------------------------

python install tips:
1. download python from >> https://www.anaconda.com/products/individual
為了防止在設定環境的過程中毀了 Anaconda。所以將建立一個虛擬環境，然後在那個虛擬環境下測試。將來如果不小心裝壞掉了，只要把那個虛擬環境殺掉就可以了，不必重新安裝anaconda，若是成功即可直接做使用。
2. open Anaconda Prompt 
3. enter: conda create -n ML -c conda-forge spyder（這會建立一個名為 ML 的虛擬環境。ML 可以改成您喜歡的名字）
4. enter: conda activate ML（這會將目前的工作環境，切換到 ML 這個虛擬環境）
5. install package: pip install numpy pandas matplotlib seaborn scipy pandas-datareader scikit-learn statsmodels pydotplus jax jaxlib tensorflow openpyxl

------------------------------------------------------------------------------

To call the python in Matlab, type following command in matlab command window:

pyversion("C:\Users\sam01\anaconda3\envs\py36\python.exe")

If success u can get the result:




------------------------------------------------------------------------------

The main code is CIFAR.m

1. Run the DownloadCIFAR10.m to download the CIFAR10 data set

2. Change the variable 'type' to set the compression scheme

------------------------------------------------------------------------------
