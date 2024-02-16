# Software AG Mainstream DevOps Style API Mockup Service

This project offers:

- an IS package that can be used as an API mockup service provider during system tests
- examples on how to deliver this package using container images
- examples of reusable build shell scripts usable with buildah
- example of local build in Windows
- example of buildah in docker container image build and push to the target repository
- pipeline examples for Azure DevOps

## Assumptions

- code authoring for the project is done in Windows. Any other OS supporting docker compose is usable, but not tested for code authoring
- CI/CD automation is executed in Linux agents and is based on the rootless build tool `buildah`

## Quick start

1. Clone the project locally
2. For code authoring:

    - go into folder `.\run-configurations\api-mockup-dev-01`
    - copy the file `example.env` into `.env`
    - edit `.env` and set up the necessary values
    - use docker compose to start or stop the authoring run-configuration
    - start up designer and connect to `http://localhost:${HOST_PORT_PREFIX}55` or better `http://host.docker.internal:${HOST_PORT_PREFIX}55`
    - author the code as needed and use git on the root folder of the project for source control

3. If you want to locally build on Windows:

    - go into the folder `.\test\localBuildWithDockerOnWindows`
    - copy the file `example.setEnv.bat` into `setEnv.bat`
    - edit `setEnv.bat` and set the necessary values
    - ensure the mentioned base image is accessible
    - run `build.bat`

4. If you want to locally test the build scripts, thus also obtaining an image in a target registry:

    - go into the folder `.\test\localFullBuildWithBuildahInDocker`
    - copy the file `example.env` into `.env`
    - edit `.env` and set up the necessary values
    - run the command `.\run.bat`

    Note that in this case you MUST push the resulting image in a given registry, the "local" registry is ephemeral, getting destroyed with the container.

## How To ?

### How to find out the user and group of the base image?

Run once, without retaining anything, the base container with a command like:

```bat
docker run --rm -it --entrypoint=/bin/sh sagcr.azurecr.io/webmethods-microservicesruntime:10.15
```

then the command id:

```sh
id

uid=1724(sagadmin) gid=1724(sagadmin) groups=1724(sagadmin)
```

### Inject non administrator user able to call the mocks

Create the following global variables:

- SagServiceMockup_mockUserName
- SagServiceMockup_mockUserPass

Example using application.properties:

```properties
# Declaring the mock user
globalvariable.SagServiceMockup_mockUserName.value=yourUserName
globalvariable.SagServiceMockup_mockUserPass.value=yourUserPass
globalvariable.SagServiceMockup_mockUserPass.isSecure=true
```

Example using application.properties and environment variables

```properties
# Declaring the mock user
globalvariable.SagServiceMockup_mockUserName.value=$env{SAG_SERVICE_MOCKUP_USER_NAME}
globalvariable.SagServiceMockup_mockUserPass.value=$env{SAG_SERVICE_MOCKUP_USER_PASS}
globalvariable.SagServiceMockup_mockUserPass.isSecure=true
```

If these variables are not passed, the following defaults apply

- User is `mockUser`
- Password is `mockPassword`


------------------------------

These tools are provided as-is and without warranty or support. They do not constitute part of the Software AG product suite. Users are free to use, fork and modify them, subject to the license agreement. While Software AG welcomes contributions, we cannot guarantee to include every contribution in the master project.
