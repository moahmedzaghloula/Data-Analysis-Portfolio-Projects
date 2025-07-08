# Import Libraries
import pandas as pd 
import numpy as np 
from scipy.signal import find_peaks
import plotly.graph_objects as go 

# 1. Data Exploration and Prepration
# Load the Dataset
df = pd.read_csv("upload_financial_quotes_202506291718.csv")

# Convert 'date' column to datetime objects and set it as index 
df["date"] = pd.to_datetime(df["date"])
df = df.set_index("date")

# Extract the 'close' prices for analysis 
close_prices =df["close"]

# Save Processed close prices to a CSV for later use 
close_prices.to_csv("processed_close_prices.csv")

# 2. Peak and Valley Detection using Scipy 
# Find peaks (local maxima)
# find_peaks function returns the indices of the peaks 
peaks, _ = find_peaks(close_prices.values.flatten())

# Find valleys (local minima) by inverting the signal 
# Multiply by -1 to turn vallyes into peaks, then apply find_peaks
valleys, _ = find_peaks(-close_prices.values.flatten())

# Save peak and valley indices to numpy files to later use
np.save("peaks.npy",peaks)
np.save("valleys.npy",valleys)

print(f"Found {len(peaks)} peaks and {len(valleys)} valleys.")

# 3. Comprehensive Interactive Visualization 
# Create a Plotly Figure 
fig = go.Figure()

# Add the close price trace
fig.add_trace(go.Scatter(x=close_prices.index,y=close_prices.values,mode="lines",name="Close Price"))

# Add peaks as scatter points
fig.add_trace(go.Scatter(x=close_prices.index[peaks],y=close_prices.values[peaks], mode="markers",name="Peaks",marker=dict(symbol="x" ,size =8 ,color="red")))

# Add valleys as a scatter points 
fig.add_trace(go.Scatter(x=close_prices.index[valleys],y=close_prices.values[valleys],mode="markers" , name ="Valleys" ,marker=dict(symbol="circle" ,size= 8 , color="green")))

# Update Layout
fig.update_layout(
    title = "Stock Price with Peaks And Valleys",
    xaxis_title = "Date",
    yaxis_title = "Price",
    hovermode = "x unified"
)

# Save the interactive plot as an HTML file
fig.write_html("stock_peaks_valleys_interactive.html")
print("Interactive plot saved to stock_peaks_valleys_interactive.html")



# Note : To display the plot in a browser (if running locally)
# fig.show()





