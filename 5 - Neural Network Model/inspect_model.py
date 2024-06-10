import pandas as pd
import numpy as np
from scipy.io import loadmat
import torch
import matplotlib.pyplot as plt
from model import Neural_network

data = loadmat('Data/20sec.mat')
ignoreSteps = 10
t = torch.tensor(data['t'][ignoreSteps:,0], dtype=torch.float64)
u = torch.reshape(torch.tensor((data['u'])[0,0,ignoreSteps:], dtype=torch.float64), (len(t),1))
y = torch.tensor(data['y'][ignoreSteps:,:3], dtype=torch.float64)
xhat = torch.tensor(data['xhat'][ignoreSteps:,:], dtype=torch.float64)

net = Neural_network()
net.load_state_dict(torch.load('Models/10sec.pth'))
net.to(torch.double)

net_in = torch.cat((u, y), dim=1)
net_out = torch.tensor(np.zeros((len(t), 3)))

net.eval()
for i in range(len(t)):
    with torch.no_grad():
        net_out[i,:] = net(net_in[i,:])

fig, (ax1, ax2) = plt.subplots(2,1)
ax1.plot(t, y[:,0])
ax1.plot(t, net_out[:,0])
ax2.plot(t, y[:,2])
ax2.plot(t, net_out[:,2])
plt.show()

