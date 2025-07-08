# Import Libraries

import pandas as pd
import numpy as np
import plotly.graph_objects as go
from scipy.signal import find_peaks

# Create Important Functions

def check_trend_line(support: bool, pivot: int, slope: float, y: np.array):
    intercept = -slope * pivot + y[pivot]
    line_vals = slope * np.arange(len(y)) + intercept
    diffs = line_vals - y
    if support and diffs.max() > 1e-5:
        return -1.0
    elif not support and diffs.min() < -1e-5:
        return -1.0
    err = (diffs ** 2.0).sum()
    return err;

def optimize_slope(support: bool, pivot:int , init_slope: float, y: np.array):
    slope_unit = (y.max() - y.min()) / len(y) 
    opt_step = 1.0
    min_step = 0.0001
    curr_step = opt_step 
    best_slope = init_slope
    best_err = check_trend_line(support, pivot, init_slope, y)
    assert(best_err >= 0.0)
    get_derivative = True
    derivative = None
    while curr_step > min_step:
        if get_derivative:
            slope_change = best_slope + slope_unit * min_step
            test_err = check_trend_line(support, pivot, slope_change, y)
            derivative = test_err - best_err;
            if test_err < 0.0:
                slope_change = best_slope - slope_unit * min_step
                test_err = check_trend_line(support, pivot, slope_change, y)
                derivative = best_err - test_err
            if test_err < 0.0:
                raise Exception("Derivative failed. Check your data.")
            get_derivative = False
        if derivative > 0.0:
            test_slope = best_slope - slope_unit * curr_step
        else:
            test_slope = best_slope + slope_unit * curr_step
        test_err = check_trend_line(support, pivot, test_slope, y)
        if test_err < 0 or test_err >= best_err:
            curr_step *= 0.5
        else:
            best_err = test_err 
            best_slope = test_slope
            get_derivative = True
    return (best_slope, -best_slope * pivot + y[pivot])

def fit_trendlines_single(data: np.array):
    x = np.arange(len(data))
    coefs = np.polyfit(x, data, 1)
    line_points = coefs[0] * x + coefs[1]
    upper_pivot = (data - line_points).argmax() 
    lower_pivot = (data - line_points).argmin() 
    support_coefs = optimize_slope(True, lower_pivot, coefs[0], data)
    resist_coefs = optimize_slope(False, upper_pivot, coefs[0], data)
    return (support_coefs, resist_coefs) 

def fit_trendlines_high_low(high: np.array, low: np.array, close: np.array):
    x = np.arange(len(close))
    coefs = np.polyfit(x, close, 1)
    line_points = coefs[0] * x + coefs[1]
    upper_pivot = (high - line_points).argmax() 
    lower_pivot = (low - line_points).argmin() 
    support_coefs = optimize_slope(True, lower_pivot, coefs[0], low)
    resist_coefs = optimize_slope(False, upper_pivot, coefs[0], high)
    return (support_coefs, resist_coefs)



# Data Exploration and Preparation

df = pd.read_csv("upload_financial_quotes_202506291718.csv")
df["date"] = pd.to_datetime(df["date"])
df = df[df["date"].dt.year == 2024]
df = df.set_index("date")
close_prices = df["close"]
high_prices = df["high"]
low_prices = df["low"]
close_prices.to_csv("processed_close_prices_2024.csv")

# 2. Peak And Valley Detection
peaks, _ = find_peaks(close_prices.values.flatten())
valleys, _ = find_peaks(-close_prices.values.flatten())
np.save("peaks_2024.npy", peaks)
np.save("valleys_2024.npy", valleys)
print(f"Found {len(peaks)} Peaks And {len(valleys)} Valleys In 2024")

# Trendline Calculation 

support_line_coords = []
resist_line_coords = []
lookback = len(df)

if lookback > 1:
    support_coefs, resist_coefs = fit_trendlines_high_low(
        high_prices.values[-lookback:], 
        low_prices.values[-lookback:], 
        close_prices.values[-lookback:]
    )

    x_coords = np.arange(lookback)
    support_line_y = support_coefs[0] * x_coords + support_coefs[1]
    resist_line_y = resist_coefs[0] * x_coords + resist_coefs[1]

    support_line_coords = [(df.index[-lookback + i], support_line_y[i]) for i in range(lookback)]
    resist_line_coords = [(df.index[-lookback + i], resist_line_y[i]) for i in range(lookback)]

# Detection trend direction and visualize 

if support_coefs[0] > 0  and resist_coefs[0] > 0 :
    trend_text = "Uptrend"
    trend_color = "green"
elif support_coefs[0] < 0 and resist_coefs[0] < 0 :
    trend_text = "Downtrend"
    trend_color= "red" 
else :
    trend_text = "SideWays / Mixed"
    trend_color = "gray"

print(f"{trend_text} detected")

# Visualization 

fig = go.Figure()
fig.add_trace(go.Scatter(
    x=close_prices.index,
    y=close_prices.values,
    mode="lines",
    name="Close Price"
    )
)
fig.add_trace(go.Scatter(
    x=close_prices.index[peaks],
    y=close_prices.values[peaks],
    mode="markers",
    name="Peaks",
    marker=dict(
        symbol="x",
        size=8,
        color="red"
        )
    )
)
fig.add_trace(go.Scatter(
    x=close_prices.index[valleys],
    y=close_prices.values[valleys],
    mode="markers",
    name="Valleys",
    marker=dict(
        symbol="circle",
        size=8,
        color="green"
        )
    )
)
if support_line_coords:
    fig.add_trace(go.Scatter(
        x=[c[0] for c in support_line_coords],
        y= [c[1] for c in support_line_coords],
        mode="lines",
        name = "Support Line",
        line = dict(
            color="blue",
            dash="dash"
        )
    )
    
)
if resist_line_coords:
    fig.add_trace(go.Scatter(
        x=[c[0] for c in resist_line_coords],
        y=[c[1] for c in resist_line_coords],
        mode="lines",
        name="Resistance Line",
        line=dict(
            color="orange",
            dash="dash"
        )
    )
)
    
# Add trend Anotation 
if lookback > 1 :
    fig.add_annotation(
        text=f"<b>{trend_text}</b>",
        x=close_prices.index[int(len(close_prices) * 0.05)],
        y=close_prices.max(),
        showarrow= False,
        font=dict(
            size=20,
            color=trend_color
        ),
        bgcolor="white",
        bordercolor=trend_color,
        borderwidth=2,
        borderpad=4
    )
fig.update_layout(
    title="Stock Price with Peaks, Valleys and Trendlines (2024)",
    xaxis_title = "Date",
    yaxis_title = "Price",
    hovermode= "x unified"
)
fig.write_html("Trendlines(2024).html")
print("Interactive plot for 2024 saved to Trendlines(2024).html")




















