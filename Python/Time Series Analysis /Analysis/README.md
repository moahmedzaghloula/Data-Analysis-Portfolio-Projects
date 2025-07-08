# Stock Price Analysis with Peaks, Valleys And Trendlines

## Project Overview
This project is a Streamlit-based web app that analyzes stock price data, detects peaks, valleys, calculates support and resistance trendlines, and visualize the results using plotly. The application processes financial data from a CSV file (`upload_financial_quotes_202506291718.csv`) and allows users to filter data by time range (All Data, Year, Month, or Custom Range). It identifies trends (Uptrend, Downtrend, or Sideways) and displays an interactive chart with stock prices, peaks, valleys, and trendlines.

The Project includes:
- **app.py** : The main Python script for Streamlit Application 
- **upload_financial_quotes_202506291718.csv** : the dataset with stock price data for `gdx.us`
- **Dockerfile** : A Docker configuration to containerize the application.

## Prerequisites 
To run this project , ensure you have the following installed:
- **Docker** : Install Docker Desktop for Windows or Docker for Linux.
- A Compatible web browser (e.g., Firefox, Chrome) to access the Streamlit App

## Setup Instructions 

### For Windows Users
1. **Install Docker Desktop**:
   - Download and install Docker Desktop from [Docker's official website](https://www.docker.com/products/docker-desktop/). 
   - Follow the installation prompts and ensure Docker Desktop is running.

2. **Pull the Docker Image**:
   - Open PowerShell or Command Prompt.
   - Pull the Docker image 
     ```bash
     docker pull mohamedzaghloula/streamlit-stock-app:latest
     ```
3. **Run the Docker Container**:
   - Run the container, mapping port 8501 (Streamlit's default port) to your local machine:
     ```bash
     docker run -p 8501:8501 mohamedzaghloula/streamlit-stock-app:latest
     ```
4. **Access the Application**:
   - Open a web browser and navigate to `http://localhost:8501` .
   - the Streamlit app should now be running.


### For Linux Users
1. **Install Docker**:
   - Install Docker on your Linux Distributions:
     ```bash
     sudo apt update 
     sudo apt install docker.io
     sudo systemctl start docker 
     sudo systemctl enable docker
     ``` 
   - Follow the installation commands and ensure Docker is running.

2. **Pull the Docker Image**:
   - Open PowerShell or Command Prompt.
   - Pull the Docker image 
     ```bash
     docker pull mohamedzaghloula/streamlit-stock-app:latest

3. **Run the Docker Container**:
   - Run the container, mapping port 8501 (Streamlit's default port) to your local machine:
     ```bash
     docker run -p 8501:8501 mohamedzaghloula/streamlit-stock-app:latest
     ```
4. **Access the Application**:
   - Open a web browser and navigate to `http://localhost:8501` .
   - the Streamlit app should now be running.

## Usage
- **Select Time Range**: Choose from "All Data", "Year", "Month", or "Custom Range" to filter stock data 
- **View Result**: The app displays:
  - The number of peaks and valleys detected in selected period.
  - The detected trend (Uptrend, Downtrend, or Sideways) 
  - An Interactive plotly chart showing stock close prices and peaks and valleys and support line and resistance line 
- **Interact with the chart** : Hover over data points to see details, zoom, or pan the chart.

## Troubleshooting 
- **Docker Image Pull Fails** : Ensure you have internet connection and the correct image name. 
- **Port Conflict** : If port 8501 is in use, change the port mapping (e.g., `-p 8502:8501`) and access the app at http://localhost:8502.
- **App Not Loading** : Verify the Docker container is running (`docker ps`) and check the container logs for errors:
  ```bash
  docker logs <container_id>
  ``` 


