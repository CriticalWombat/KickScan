# KickScan Project

**KickScan** aims to provide a straightforward way to set up and manage physical deployments of GreenBone Vulnerability Management system using Docker. By leveraging Docker containers, KickScan ensures that the environment is consistent, isolated, and easy to maintain. The provided scripts handle everything from user and group creation to the installation and configuration of Docker and GreenBone.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [License](#license)

## Prerequisites

Before you begin, ensure you have the following:

- A Linux-based system or WSL to generate the custom ISO file
- Root or sudo access to the system or WSL
- Internet connection for both your current Linux/WSL instance as well as your target device that you are installing the OS on.

## Installation

To install and set up KickScan, follow these steps:

1. **Download the `iso_gen_bash` script**:

    ```bash
    curl -o iso_gen_bash https://raw.githubusercontent.com/CriticalWombat/KickScan/main/iso_gen_bash
    chmod +x iso_gen_bash
    ```

2. **Run the `iso_gen_bash` script**:
    This script generates an ISO file for the KickScan installation.

    ```bash
    ./iso_gen_bash
    ```

3. **Use the generated ISO**:
    Boot the generated ISO on the target system. The ISO will handle the installation process using the provided Kickstart configuration and Docker setup scripts.

4. **Log into root and set the non-root account password**:
    Once a login prompt is available, login to the root account and set a password for the non-root account.
    ```bash
    passwd useraccountnamehere
    ``` 

5. **Log into the user account**:
    Either log out of the root account or switch users to the non-root account.
    ```bash
    su useraccountnamehere
    ```

6. **First time logon script will handle the setup and configuration of Docker and Greenbone.**:
    Simply wait for the script to complete and you will be presented with messsage indicating where your web interface can be reached.

## Configuration

The provided configuration files and scripts are used during the installation process:

- `config.sh`: Sets up necessary users, groups, and installs Docker along with required dependencies.
- `docker.sh`: Sets up the GreenBone Docker environment and starts the necessary containers.
- `compose.yaml`: Docker Compose file for defining the GreenBone services.

These scripts are automatically executed during the installation process initiated by the Kickstart configuration. No manual execution is necessary.

## Usage

After the installation, you can access the GreenBone Vulnerability Management interface by navigating to `http://localhost:5555` of the target device that was deployed.


## License

This project is licensed under the MIT License.