#Python code

import pandas as pd
import matplotlib.pyplot as plt
import os

h = ['k', 'count_of_author']
df_vis = pd.read_csv('/home/shubhika/Downloads/DBSYS/temp_vis.csv', names=h)
number_of_publications = df_vis.k[1:].astype(int).to_list()
number_of_authors = df_vis.count_of_author[1:].astype(int).to_list()

#Plotting the graph
plt.bar(number_of_authors,number_of_publications,color='deepskyblue',align='center',orientation='vertical')

#Convert the axes to Logarithmic scale
plt.xscale('log')
plt.yscale('log')

#Labelling the axes and giving title to the graph
plt.title("Data Visualization- (Power Law)")
plt.xlabel('COUNT OF AUTHORS')
plt.ylabel('COUNT OF PUBLICATIONS')

#Saving the graph figure
plt.savefig('/home/shubhika/Downloads/DBSYS/vis.pdf')

#removing the csv file 
os.remove("/home/shubhika/Downloads/DBSYS/temp_vis.csv")
