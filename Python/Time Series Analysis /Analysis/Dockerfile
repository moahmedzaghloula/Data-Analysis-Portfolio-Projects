FROM python:3.13-slim

WORKDIR /app

COPY  app.py upload_financial_quotes_202506291718.csv /app/

RUN pip install streamlit pandas numpy plotly scipy

EXPOSE 8501

CMD [ "streamlit" , "run" , "app.py" ]

