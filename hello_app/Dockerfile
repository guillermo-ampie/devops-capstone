FROM python:3.7-slim-buster

LABEL author="ga.ampie@gmail.com"

# Working Directory
WORKDIR /app

# Copy source code to working directory
COPY . /app/

# Install packages from requirements.txt
# hadolint ignore=DL3013
RUN pip install  --upgrade pip && \
    pip install  --trusted-host pypi.python.org -r requirements.txt

# Expose port 80
EXPOSE 80

# Run app at container launch
CMD ["python", "hello.py"]
