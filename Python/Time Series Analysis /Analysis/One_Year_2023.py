# Import Libraries
import pandas as pd 
import numpy as np 
from scipy.signal import find_peaks 
import plotly.graph_objects as go 

# 1. Data Exploration and Preparation
# Load the Dataset
df = pd.read_csv("upload_financial_quotes_202506291718.csv")

# Convert 'date' column to datetime objects
df["date"] = pd.to_datetime(df["date"])

# Filter data for the year 2023
df = df[df["date"].dt.year==2023]

# Set 'date' as index 
df = df.set_index("date")

# Extract the 'close' prices for analysis 
close_prices = df["close"]

# Saved Processed close prices to a CSV for later use
close_prices.to_csv("processed_close_prices_2023.csv")

# 2. Peak And Valley Detection using Scipy
# Find peaks (local maxima)
peaks,_ =find_peaks(close_prices.values.flatten())

# # Find valleys (local minima) by inverting the signal 
valleys,_=find_peaks(-close_prices.values.flatten())

# Save Peak and Valley indices to numpy files for later use 
np.save("peaks_2023.npy" , peaks)
np.save("valleys_2023.npy",valleys)

print(f"Found {len(peaks)} Peaks And {len(valleys)} Valleys In 2023")

# 3. Comprehensive Interactive Visualization
fig = go.Figure()

# Add The Close Price Trace
fig.add_trace(go.Scatter(x=close_prices.index,y=close_prices.values,mode="lines" , name="Close Price"))

# Add peaks as scatter points
fig.add_trace(go.Scatter(x=close_prices.index[peaks], y=close_prices.values[peaks], mode="markers", name="Peaks", marker=dict(symbol="x", size=8, color="red")))

# Add valleys as scatter points 
fig.add_trace(go.Scatter(x=close_prices.index[valleys], y=close_prices.values[valleys], mode="markers", name="Valleys", marker=dict(symbol="circle", size=8, color="green")))


# Update Layout
fig.update_layout(
    title="Stock Price with Peaks and Valleys (2023)",
    xaxis_title="Date",
    yaxis_title="Price",
    hovermode="x unified"
)

# Save the Interactive plot as an HTML file 
fig.write_html("Stock_peaks_valleys_2023.html")
print("Interactive plot for 2023 saved to Stock_peaks_valleys_2023.html")

# Note : To Display the plot in a browser (if running it locally)
# fig.show()




