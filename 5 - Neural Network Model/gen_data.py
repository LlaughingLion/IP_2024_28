import pandas as pd
import numpy as np
from scipy.io import loadmat

data = loadmat('Data/10sec.mat')
t = data['t'][:,0]
u = (data['u'])[0,0,:]
y = data['y']
xhat = data['xhat']

ignoreSteps = 10

df = pd.DataFrame({'u': u[ignoreSteps:-1], 'x1': [list(x) for x in xhat[ignoreSteps:-1, :]], 'x2': [list(x) for x in xhat[ignoreSteps+1:, :]]})

df['x1'] = df['x1'].apply(lambda x: ' '.join(map(str, x)))
df['x2'] = df['x2'].apply(lambda x: ' '.join(map(str, x)))

df.to_csv('Data/10sec.csv', index=False)