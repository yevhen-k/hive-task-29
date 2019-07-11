#%%
import pandas as pd
import numpy as np

#%%
df = pd.read_csv('Video_Games_Sales_as_at_22_Dec_2016.csv')

#%%
df.head()

#%%
df['Platform'].nunique()

#%%
df['Platform'].unique()

#%%
df.dropna(inplace=True)

#%%
max_sales_eu_by_year = df.groupby(by='Year_of_Release')['EU_Sales'].agg({
    'EU_Sales': lambda series: np.max(series)
}).reset_index()

#%%
groupper = df.groupby(by='Year_of_Release')
name = []
eu_sales = []
yor = []
platform = []
for idx, group in enumerate(groupper):
    for idy, sales in enumerate(group[1]['EU_Sales']):
        if sales == max_sales_eu_by_year['EU_Sales'][idx]:
            name.append(group[1]['Name'].iloc[idy])
            eu_sales.append(sales)
            yor.append(max_sales_eu_by_year['Year_of_Release'][idx])
            platform.append(group[1]['Platform'].iloc[idy])

data = {
    'Name': name, 
    'EU_Sales': eu_sales, 
    'Year_of_Release': yor, 
    'Platform': platform
}
result = pd.DataFrame(data=data, columns=['Name', 'EU_Sales', 'Year_of_Release', 'Platform'])
                
print(result)