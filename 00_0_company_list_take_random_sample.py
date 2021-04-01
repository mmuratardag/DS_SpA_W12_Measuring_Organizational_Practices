import pandas as pd
df['letter'] = df['company'].astype(str).str[0]
df_ss = df.groupby("letter").sample(frac=0.45, random_state=666)
df_ss = df_ss['company']
df_ss.to_csv('company_list_ss.csv', index=False)
