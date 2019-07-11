#%%
import pandas as pd

#%%
df = pd.read_csv('Video_Games_Sales_as_at_22_Dec_2016.csv')

#%%
df.head()

#%%
df['Platform'].nunique()

#%%
df['Platform'].unique()

#%%
