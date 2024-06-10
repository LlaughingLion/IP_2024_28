import torch
import torch.nn as nn
import torch.nn.functional as F


class Neural_network(nn.Module): # inherit the nn.Module class for backpropagation and training functionalities
    #Build the layers of the network, and initializes the parameters
    def __init__(self): 
        super(Neural_network, self).__init__()
        self.fc1 = nn.Linear(4, 8, bias = True)
        self.fc2 = nn.Linear(8, 16, bias = True) 
        self.fc3 = nn.Linear(16, 64, bias = True) 
        self.fc4 = nn.Linear(64, 3, bias = True)

        self.tanh = F.tanh
        self.sigmoid = F.sigmoid
        self.relu = F.relu
    
    #Build the forward call 
    def forward(self, x):
        if x.dim() == 1:  # If x is a 1D tensor, add a batch dimension
            x = x.unsqueeze(0)
        x = torch.flatten(x, start_dim = 1)
        x = self.fc1(x) 
        x = self.tanh(x) 
        x = self.fc2(x)
        x = self.tanh(x)
        x = self.fc3(x)
        x = self.tanh(x)
        x = self.fc4(x)
        return x
    