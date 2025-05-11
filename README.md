<p align="center">
    <a href="https://www.coozila.com/plus/view-organization-profile/coozila" target="_blank">
        <img src="https://img.shields.io/badge/Follow_on-Coozila!-1c7ed6?style=flat" alt="Follow on Coozila!" />
    </a>
</p>

<p align="center">
    <img width="233px" height="auto" src="https://www.coozila.com/static/themes/prometheus/img/coozila.png" />
</p>

<p align="center">
    <a href="https://github.com/kabballa/PHP-UNA/dev/main/LICENSE" target="_blank">
        <img src="https://img.shields.io/badge/license-MIT-1c7ed6" alt="License" />
    </a>
</p>

> If you enjoy the project, please consider giving us a GitHub star ⭐️. Thank you!

## Sponsors

If you want to support our project and help us grow, you can [become a sponsor on GitHub](https://github.com/sponsors/coozila).

<p align="center">
    <a href="https://github.com/sponsors/coozila"></a>
</p>

# Introducing Kabballa: PHP-FPM for UNA Applications Deployment

<p align="center">
    <img src="assets/kabballa.jpeg" alt="Kabballa PHP Setup" />
</p>

Kabballa is a cutting-edge application designed to streamline the management and deployment of modern, scalable infrastructures. This platform supports a wide array of technologies, including:

- MySQL
- Redis
- Nginx
- PHP
- Golang
- Vite
- Node.js
- Memcached
- Elasticsearch
- And more!

Leveraging the power of Kubernetes (K8s) or Docker Swarm, Kabballa provides an efficient way to host and orchestrate applications across multiple environments. Soon, Kabballa will become open source, inviting the community to contribute and innovate.

<p align="center">
    <img src="assets/php-setup.png" alt="Kabballa PHP" />
</p>

### **Final Goal**

The ultimate aim is to launch UNA Apps in a global multicloud environment, ensuring redundancy and scalability using Karmada and Kubernetes.

## Features

- Install PHP-FPM
- Configure PHP settings dynamically using `.env` files.

## ⚠️ Installation Instructions

Follow these steps to install and configure PHP using this script:

1. Clone or download the script to your server:
   ```bash
   git clone https://github.com/kabballa/PHP-UNA.git
   cd PHP-UNA
   ```

2. Make the script executable:
   ```bash
   chmod +x php-setup.sh
   ```

3. Copy the `.env.example` file to `.env` and customize it:
   ```bash
   cp .env.example .env
   ```

   - Open the `.env` file in your preferred text editor and modify the values as needed.
   - The `.env` file allows you to override the default settings in `php.sh` for PHP, Opcache, Memcached, and PHP-FPM configurations.

4. Run the script with root privileges:
   ```bash
   sudo ./php-setup.sh
   ```

5. During execution, the script will prompt you to select PHP versions to install. You can:
   - Press Enter to install the default version (8.2).
   - Type `all` to install all supported versions (7.4, 8.0, 8.1, 8.2).
   - Specify one or more versions separated by spaces (e.g., `7.4 8.1`).

6. The script will automatically install and configure:
   - PHP and its required modules.
   - Memcached and Imagick extensions for each PHP version.

7. Verify the installation:
   - Check installed PHP versions:
     ```bash
     php -v
     ```
   - Check installed extensions:
     ```bash
     php -m
     ```

8. If you encounter any issues, review the script logs for debugging.

## Using the `.env` File for Customization

The `.env` file is used to override the default values in the `php.sh` script. By default, the script uses predefined values for PHP, Opcache, Memcached, and PHP-FPM settings. To customize these settings:

1. Copy the `.env.example` file to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Open the `.env` file in your preferred text editor and modify the values as needed. For example:
   ```bash
   MEMORY_LIMIT=65536M
   UPLOAD_MAX_FILESIZE=8192M
   POST_MAX_SIZE=8192M
   ```

3. Save the file and re-run the script to apply the changes:
   ```bash
   sudo ./php-setup.sh
   ```

> **Note**: If a variable is not defined in the `.env` file, the script will fall back to its default value.

## PHP Extensions Installed by the Script

This script installs the following PHP extensions for each selected PHP version:

- **Core Extensions**:
  - `php-fpm`
  - `php-cli`
  - `php-dev`

- **Common Extensions**:
  - `php-curl`
  - `php-gd`
  - `php-mbstring`
  - `php-zip`
  - `php-mysql`
  - `php-exif`
  - `php-fileinfo`
  - `php-opcache`
  - `php-readline`
  - `php-xml`
  - `php-soap`
  - `php-intl`
  - `php-bcmath`

- **PECL Extensions**:
  - `memcached` (via PECL)
  - `imagick` (via PECL)

> **Note**: The script installs only the PHP extensions. It does not install the Memcached or DragonflyDB servers. Refer to the "Important Notes on Memcached and DragonflyDB" section for more details.

## Important Notes on Memcached and DragonflyDB

This script **does not install the Memcached server**. It only installs the PHP extensions required to interact with Memcached. If you want to use Memcached, you need to install the Memcached server separately.

Alternatively, you can use **DragonflyDB** as a modern replacement for Memcached. DragonflyDB is a high-performance, scalable in-memory database that supports Memcached and Redis protocols. It can be used as a drop-in replacement for Memcached in your infrastructure.

To install Memcached or DragonflyDB, follow their respective installation guides:

- **Memcached Cluster (Kabballa Compatible)**: [Memcached Cluster Installation Guide](https://github.com/kabballa/memcached-cluster)
- **DragonflyDB Cluster (Kabballa Compatible)**: [DragonflyDB Cluster Installation Guide](https://github.com/kabballa/dragonflydb-cluster)

## Predefined PHP Settings and Customization

This script uses a `.env` file for customization. The `.env.example` file provided in the repository contains all the configurable settings with default values. To customize these settings:

1. Copy the `.env.example` file to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Open the `.env` file in your preferred text editor and modify the values as needed.

3. The script will automatically load the `.env` file and apply the settings during execution.

### Example Customization

To increase the memory limit and upload size, modify the `.env` file as follows:
```bash
MEMORY_LIMIT=65536M
UPLOAD_MAX_FILESIZE=8192M
POST_MAX_SIZE=8192M
```

Save the file and re-run the script to apply the changes.

## Execute the Script Using `curl`

If you prefer not to clone the repository, you can download and execute the script interactively using the following commands:

1. Run the following command to download and execute the script:
    ```bash
    curl -sSL -o php.sh https://raw.githubusercontent.com/kabballa/PHP-UNA/main/php.sh
    chmod +x php.sh
    ./php.sh
    ```

2. Follow the on-screen prompts to complete the installation process.

> **Note**: Ensure you review the script before executing it to understand its functionality and verify its safety.

## PHP Documentation and License

- Official PHP Documentation: [https://www.php.net/docs.php](https://www.php.net/docs.php)
- PHP License: [https://www.php.net/license/](https://www.php.net/license/)

## Trademarks and Copyright

This software listing is packaged by Coozila!. All trademarks mentioned are the property of their respective owners, and their use does not imply any affiliation or endorsement.

### Copyright

Copyright (C) 2009 - 2025 Coozila! Licensed under the MIT License.

### Licenses

- Coozila!: MIT License
- PHP: [PHP License](https://www.php.net/license/)

## Disclaimer

This product is provided "as is," without any guarantees or warranties regarding its functionality, performance, or reliability. By using this product, you acknowledge that you do so at your own risk. Coozila! and its contributors are not liable for any issues, damages, or losses that may arise from the use of this product. We recommend thoroughly testing the product in your own environment before deploying it in a production setting.

Happy coding!
## How to Fork and Modify the Repository

1. **Fork the Repository**:
    - Go to the [GitHub repository](https://github.com/kabballa/PHP-UNA).
    - Click the "Fork" button in the top-right corner to create your own copy of the repository.

2. **Clone Your Fork**:
    - Clone the forked repository to your local machine:
      ```bash
      git clone https://github.com/<your-username>/PHP-UNA.git
      cd PHP-UNA
      ```

3. **Configure Git Username and Email**:
    - Before committing changes, ensure your Git username and email are configured:
      ```bash
      git config --global user.name "Your Name"
      git config --global user.email "your-email@example.com"
      ```

    - You can verify the configuration with:
      ```bash
      git config --global --list
      ```

4. **Make Changes**:
    - Modify the files as needed using your preferred text editor or IDE.
    - After making changes, stage and commit them:
      ```bash
      git add .
      git commit -m "Your commit message"
      ```

5. **Push Changes**:
    - Push your changes to your forked repository:
      ```bash
      git push origin main
      ```

6. **Sign Your Commits**:
    - All pull requests must have signed commits to be accepted. To sign your commits, configure GPG signing in Git:
      ```bash
      git config --global user.signingkey <your-gpg-key-id>
      git config --global commit.gpgsign true
      ```

    - If you don't have a GPG key, generate one using:
      ```bash
      gpg --full-generate-key
      ```

    - After generating the key, list your keys to find the key ID:
      ```bash
      gpg --list-secret-keys --keyid-format=long
      ```

    - Add the key to your GitHub account by exporting it:
      ```bash
      gpg --armor --export <your-gpg-key-id>
      ```

    - Copy the output and add it to your GitHub account under **Settings > SSH and GPG keys > New GPG key**.

    - When committing, ensure your commits are signed:
      ```bash
      git commit -S -m "Your commit message"
      ```

7. **Create a Pull Request**:
    - Go to your forked repository on GitHub.
    - Click "Compare & pull request" to propose your changes to the original repository.

## Execute the Script Using `curl`

If you prefer not to clone the repository, you can directly execute the script using `curl`:

1. Run the following command to download and execute the script:
    ```bash
    curl -sSL -o php.sh https://raw.githubusercontent.com/kabballa/PHP-UNA/main/php.sh
    chmod +x php.sh
    ./php.sh
    ```

2. Follow the on-screen prompts to complete the installation process.

> **Note**: Ensure you review the script before executing it to understand its functionality and verify its safety.