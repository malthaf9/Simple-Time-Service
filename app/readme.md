
# Simple Time Sevice application

`SimpleTimeService` is a simple microservice built with Flask that returns a JSON response containing the current timestamp and the visitor's IP address.

# Requirements
- **Python 3.x**
- **Docker** to containerize the app.
- **Git** for version control.
- **DockerHub** (or other public container registries) for publishing the image.

# Application Behavior

This application exposes a single endpoint `/`, which responds with a JSON structure like the following:

```json
{
  "timestamp": "<current date and time>",
  "ip": "<visitor's IP address>"
}
```
# Project Structure

simpletimeservice/
│
├── app/                        # Application files and Dockerfile
│   ├── app.py                  # Python Flask application file
│   ├── Dockerfile              # Dockerfile configuration for the app
│   ├── requirements.txt        # Python dependencies
│   └── .dockerignore           # File to ignore unnecessary files in Docker context
│
└── README.md                   # Project documentation

# Docker Setup

## 1. Clone the Repository

```
git clone https://github.com/<yourusername>/simpletimeservice.git
cd simpletimeserviceve the example
```

## 2. Build the Docker Image

Once inside the project directory, build the Docker image with the following command:

```
docker build -t simpletimeservice .
```

This command will create a Docker image tagged simpletimeservice that contains the Flask application.


## 3. Run the Docker Container

After building the Docker image, run it using:   

```
docker run -p 5000:5000 simpletimeservice
```

This will map port 5000 from the container to port 5000 on your host machine. You can then access the app at:

```
http://localhost:5000/
```

## 4. Test the Application
   
Once the container is running, you can test it with curl or by opening the URL in your browser:

```
curl http://localhost:5000/
```

It should return something like:

```
{
  "timestamp": "2025-04-16T12:34:56Z",
  "ip": "192.168.0.1"
}

```

## Running as a Non-Root User

The application is configured to run as a non-root user within the Docker container for security best practices. The Dockerfile includes user creation and permission settings to ensure this.

## Notes

Environment Variables: You can pass environment variables when running the container using the -e flag.

Example:

```
docker run -p 5000:5000 -e MY_ENV_VAR=value simpletimeservice

```

## Code Quality and Style

- The code is well-documented, and functions are named appropriately.
- The Dockerfile follows best practices for a small and efficient image, avoiding unnecessary bloat.
- Docker image uses a non-root user to ensure secure execution within the container.







## Built With

* [Dropwizard](http://www.dropwizard.io/1.0.2/docs/) - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Billie Thompson** - *Initial work* - [PurpleBooth](https://github.com/PurpleBooth)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc


