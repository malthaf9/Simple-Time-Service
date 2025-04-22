# Use the official Python image with Alpine for a smaller footprint
FROM python:3.10-alpine

# Set the working directory
WORKDIR /app

# Copy requirements.txt and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Create a non-root user and switch to it
RUN addgroup -S appuser && adduser -S appuser -G appuser
USER appuser

# Expose the port the app runs on
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]









