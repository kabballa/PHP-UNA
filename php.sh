# ----------------------------------------------------------------------------------#
#                                                                                   #
#   Copyright (C) 2009 - 2025 Coozila! Licensed under the MIT License.              #
#   Coozila! Team    lab@coozila.com                                                #
#                                                                                   #
# ----------------------------------------------------------------------------------#

#   Script: php-setup.sh                                                            #
#   Description:                                                                    #
#       This script automates the installation, configuration, and management of    #
#       multiple PHP versions, along with their extensions and dependencies. It     #
#       also configures MariaDB with optimized settings.                            #
# ----------------------------------------------------------------------------------#
#   Features:                                                                       #
#       1. Adds the sury.org PHP repository for managing PHP versions.              #
#       2. Installs shared dependencies required for PHP and its extensions.        #
#       3. Installs and configures multiple PHP versions (7.4, 8.1, 8.2).           #
#       4. Configures php.ini settings for each PHP version.                        #
#       5. Configures Opcache settings for each PHP version.                        #
#       6. Configures PHP-FPM pool settings for each PHP version.                   #
#       7. Updates the PECL channel for managing PHP extensions.                    #
#       8. Installs and configures Memcached extension for each PHP version.        #
#       9. Installs and configures Imagick extension for each PHP version.          #
#      10. Verifies installed extensions for each PHP version.                      #
#      11. Configures MariaDB with optimized settings for performance.              #
# ----------------------------------------------------------------------------------#
#   Usage:                                                                          #
#       1. Ensure the script is executable:                                         #
#          chmod +x php-setup.sh                                                    #
#       2. Run the script with root privileges:                                     #
#          sudo ./php-setup.sh                                                      #
# ----------------------------------------------------------------------------------#
#   Notes:                                                                          #
#       - The script assumes a Debian-based system with apt package manager.        #
#       - Ensure that the sury.org repository is accessible.                        #
#       - MariaDB configuration changes are applied to                              #
#       - `/etc/mysql/mariadb.conf.d/50-server.cnf`.                                #
#       - PHP extensions are managed using PECL and built manually if necessary.    #
# ----------------------------------------------------------------------------------#
#   Author: Coozila! Team                                                           #
#   Contact: lab@coozila.com                                                        #
#   License: MIT                                                                    #
# ----------------------------------------------------------------------------------#
#!/usr/bin/env bash
set -e

# ----------------------------------------------------------------------------------#
#   STEP 1: Add sury.org PHP repository if not already added                        #
# ----------------------------------------------------------------------------------#

sudo apt install -y gnupg2 ca-certificates lsb-release wget
wget -qO - https://packages.sury.org/php/apt.gpg | sudo gpg --dearmor -o /usr/share/keyrings/php-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/php-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list

sudo apt update

# ----------------------------------------------------------------------------------#
#   STEP 2: Define PHP versions to configure                                        #
# ----------------------------------------------------------------------------------#

# List of PHP versions to install and configure
PHP_VERSIONS=("7.4" "8.1" "8.2")
echo "PHP versions to be configured: ${PHP_VERSIONS[*]}"

# ----------------------------------------------------------------------------------#
#   STEP 3: Install shared dependencies                                             #
# ----------------------------------------------------------------------------------#

install_shared_dependencies() {
    echo "Installing shared dependencies..."
    sudo apt-get update -y
    sudo apt-get install -y \
        gcc \
        g++ \
        make \
        autoconf \
        libc-dev \
        pkg-config \
        zlib1g-dev \
        libmemcached-dev \
        libssl-dev \
        libmagickwand-dev \
        libmsgpack-dev

    if [ $? -eq 0 ]; then
        echo "Shared dependencies installed successfully."
    else
        echo "Failed to install shared dependencies. Exiting."
        exit 1
    fi
}

# Execute the function
install_shared_dependencies

# ----------------------------------------------------------------------------------#
#   STEP 4: Install PHP and its modules for each version                            #
# ----------------------------------------------------------------------------------#

install_php_versions() {
    for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
        echo "Installing PHP $PHP_VERSION and required modules..."
        sudo DEBIAN_FRONTEND=noninteractive apt install -y \
            php$PHP_VERSION \
            php$PHP_VERSION-fpm \
            php$PHP_VERSION-cli \
            php$PHP_VERSION-dev \
            php-pear \
            php$PHP_VERSION-curl \
            php$PHP_VERSION-gd \
            php$PHP_VERSION-mbstring \
            php$PHP_VERSION-zip \
            php$PHP_VERSION-mysql \
            php$PHP_VERSION-exif \
            php$PHP_VERSION-fileinfo \
            php$PHP_VERSION-opcache \
            php$PHP_VERSION-readline \
            php$PHP_VERSION-xml \
            php$PHP_VERSION-soap \
            php$PHP_VERSION-intl \
            php$PHP_VERSION-bcmath
        if [ $? -eq 0 ]; then
            echo "PHP $PHP_VERSION installed successfully."
        else
            echo "Failed to install PHP $PHP_VERSION. Exiting."
            exit 1
        fi
    done
}

# Execute the function
install_php_versions

# ----------------------------------------------------------------------------------#
#   STEP 5: Configure php.ini settings for each PHP version                         #
# ----------------------------------------------------------------------------------#

configure_php_ini() {
    PHP_VERSION=$1
    echo "Configuring php.ini for PHP $PHP_VERSION..."

    sudo sed -i \
      -e '/^\s*memory_limit\s*=/d'                         -e "/^\[PHP\]/a memory_limit = 32768M" \
      -e '/^\s*post_max_size\s*=/d'                        -e "/^\[PHP\]/a post_max_size = 4096M" \
      -e '/^\s*upload_max_filesize\s*=/d'                  -e "/^\[PHP\]/a upload_max_filesize = 4096M" \
      -e '/^\s*allow_url_fopen\s*=/d'                      -e "/^\[PHP\]/a allow_url_fopen = On" \
      -e '/^\s*allow_url_include\s*=/d'                    -e "/^\[PHP\]/a allow_url_include = Off" \
      -e '/^\s*short_open_tag\s*=/d'                       -e "/^\[PHP\]/a short_open_tag = On" \
      -e '/^\s*disable_functions\s*=/d'                    -e "/^\[PHP\]/a disable_functions =" \
      -e '/^\s*opcache\.enable\s*=/d'                      -e "/^\[opcache\]/a opcache.enable = 1" \
      -e '/^\s*opcache\.revalidate_freq\s*=/d'             -e "/^\[opcache\]/a opcache.revalidate_freq = 0" \
      -e '/^\s*opcache\.memory_consumption\s*=/d'          -e "/^\[opcache\]/a opcache.memory_consumption = 256" \
      -e '/^\s*date\.timezone\s*=/d'                       -e "/^\[Date\]/a date.timezone = Europe/London" \
      /etc/php/$PHP_VERSION/fpm/php.ini /etc/php/$PHP_VERSION/cli/php.ini

    if [ $? -eq 0 ]; then
        echo "php.ini configured successfully for PHP $PHP_VERSION."
    else
        echo "Failed to configure php.ini for PHP $PHP_VERSION. Exiting."
        exit 1
    fi
}

# Apply configuration for all PHP versions
for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
    configure_php_ini "$PHP_VERSION"
done

# ----------------------------------------------------------------------------------#
#   STEP 6: Configure opcache settings for each PHP version                         #
# ----------------------------------------------------------------------------------#

configure_opcache() {
    PHP_VERSION=$1
    echo "Configuring opcache for PHP $PHP_VERSION..."

    sudo sed -i \
      -e '/^\s*opcache\.enable\s*=/d'                           -e "/^\[opcache\]/a opcache.enable = 1" \
      -e '/^\s*opcache\.revalidate_freq\s*=/d'                  -e "/^\[opcache\]/a opcache.revalidate_freq = 0" \
      -e '/^\s*opcache\.validate_timestamps\s*=/d'              -e "/^\[opcache\]/a opcache.validate_timestamps = 1" \
      -e '/^\s*opcache\.max_accelerated_files\s*=/d'            -e "/^\[opcache\]/a opcache.max_accelerated_files = 200000" \
      -e '/^\s*opcache\.memory_consumption\s*=/d'               -e "/^\[opcache\]/a opcache.memory_consumption = 256" \
      -e '/^\s*opcache\.max_wasted_percentage\s*=/d'            -e "/^\[opcache\]/a opcache.max_wasted_percentage = 20" \
      -e '/^\s*opcache\.interned_strings_buffer\s*=/d'          -e "/^\[opcache\]/a opcache.interned_strings_buffer = 16" \
      -e '/^\s*opcache\.fast_shutdown\s*=/d'                    -e "/^\[opcache\]/a opcache.fast_shutdown = 1" \
      /etc/php/$PHP_VERSION/fpm/conf.d/10-opcache.ini

    if [ $? -eq 0 ]; then
        echo "Opcache configured successfully for PHP $PHP_VERSION."
    else
        echo "Failed to configure opcache for PHP $PHP_VERSION. Exiting."
        exit 1
    fi
}

# Apply opcache configuration for all PHP versions
for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
    configure_opcache "$PHP_VERSION"
done

# ----------------------------------------------------------------------------------#
#   STEP 7: Configure PHP-FPM pool settings for each PHP version                    #
# ----------------------------------------------------------------------------------#

configure_fpm_pool() {
    PHP_VERSION=$1
    echo "Configuring PHP-FPM pool for PHP $PHP_VERSION..."

    sudo sed -i \
      -e '/^\s*listen\s*=.*/d'                    -e "/^\[www\]/a listen = /run/php/php$PHP_VERSION-fpm.sock" \
      -e '/^\s*listen\.owner\s*=.*/d'             -e "/^\[www\]/a listen.owner = www-data" \
      -e '/^\s*listen\.group\s*=.*/d'             -e "/^\[www\]/a listen.group = www-data" \
      -e '/^\s*listen\.mode\s*=.*/d'              -e "/^\[www\]/a listen.mode = 0660" \
      -e '/^\s*pm\s*=.*/d'                        -e "/^\[www\]/a pm = dynamic" \
      -e '/^\s*pm\.max_children\s*=.*/d'          -e "/^\[www\]/a pm.max_children = 128" \
      -e '/^\s*pm\.start_servers\s*=.*/d'         -e "/^\[www\]/a pm.start_servers = 12" \
      -e '/^\s*pm\.min_spare_servers\s*=.*/d'     -e "/^\[www\]/a pm.min_spare_servers = 6" \
      -e '/^\s*pm\.max_spare_servers\s*=.*/d'     -e "/^\[www\]/a pm.max_spare_servers = 24" \
      -e '/^\s*pm\.max_requests\s*=.*/d'          -e "/^\[www\]/a pm.max_requests = 0" \
      -e '/^\s*rlimit_files\s*=.*/d'              -e "/^\[global\]/a rlimit_files = 65536" \
      -e '/^\s*rlimit_core\s*=.*/d'               -e "/^\[global\]/a rlimit_core = 0" \
      /etc/php/$PHP_VERSION/fpm/pool.d/www.conf

    if [ $? -eq 0 ]; then
        echo "PHP-FPM pool configured successfully for PHP $PHP_VERSION."
    else
        echo "Failed to configure PHP-FPM pool for PHP $PHP_VERSION. Exiting."
        exit 1
    fi
}

# Apply PHP-FPM pool configuration for all PHP versions
for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
    configure_fpm_pool "$PHP_VERSION"
done

# ----------------------------------------------------------------------------------#
#   STEP 8: Restart PHP-FPM service for a specific PHP version                      #
# ----------------------------------------------------------------------------------#

if systemctl list-units --type=service | grep -q "php$PHP_VERSION-fpm.service"; then
    sudo systemctl restart php$PHP_VERSION-fpm
else
    echo "PHP-FPM service for PHP $PHP_VERSION not found."
fi


# ----------------------------------------------------------------------------------#
#   STEP 9: Update PECL channel                                                     #
# ----------------------------------------------------------------------------------#

update_pecl_channel() {
    echo "Updating PECL channel..."

    # Check if PECL is installed
    if ! command -v pecl &> /dev/null; then
        echo "✘ PECL is not installed. Please install php-pear first."
        exit 1
    fi

    # Update PECL channel
    sudo pecl channel-update pecl.php.net

    if [ $? -eq 0 ]; then
        echo "✔ PECL channel updated successfully."
    else
        echo "✘ PECL channel update failed."
        exit 1
    fi
}

# Execute the function
update_pecl_channel

# ----------------------------------------------------------------------------------#
#   STEP 10: Verify and handle Memcached installation                               #
# ----------------------------------------------------------------------------------#

# Function to verify and handle Memcached installation
verify_and_handle_memcached() {
    for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
        echo "🔍 Checking Memcached for PHP $PHP_VERSION..."

        PHP_BIN="/usr/bin/php$PHP_VERSION"
        if [ ! -x "$PHP_BIN" ]; then
            echo "⚠ PHP $PHP_VERSION binary not found. Skipping."
            echo "---------------------------------------------"
            continue
        fi

        # Verifică dacă pecl e prezent
        PECL_BIN="/usr/bin/pecl"
        if [ ! -x "$PECL_BIN" ]; then
            echo "✘ pecl not found. Install php-pear first."
            echo "---------------------------------------------"
            continue
        fi

        # Verifică dacă memcached e instalat pentru versiunea asta de PHP
        if PHP_PEAR_PHP_BIN=$PHP_BIN $PECL_BIN list | grep -q 'memcached'; then
            echo "✔ Memcached is installed for PHP $PHP_VERSION. Uninstalling..."
            uninstall_memcached "$PHP_VERSION"
        else
            echo "✘ Memcached is NOT installed for PHP $PHP_VERSION."
        fi

        # După verificare/ștergere, instalează Memcached
        echo "➡ Installing Memcached for PHP $PHP_VERSION..."
        install_memcached "$PHP_VERSION"

        echo "---------------------------------------------"
    done
}

# Execute the function
verify_and_handle_memcached

# ----------------------------------------------------------------------------------#
#   Uninstall Memcached extension if installed                                      #
# ----------------------------------------------------------------------------------#

uninstall_memcached() {
    PHP_VERSION="$1"
    echo "Uninstalling Memcached for PHP $PHP_VERSION..."

    INSTALLED=$(PHP_PEAR_PHP_BIN=/usr/bin/php$PHP_VERSION pecl list | awk '{print $1}' | grep -w memcached)

    if [ "$INSTALLED" = "memcached" ]; then
        echo "✔ Memcached found for PHP $PHP_VERSION. Removing via PECL..."
        echo "" | PHP_PEAR_PHP_BIN=/usr/bin/php$PHP_VERSION pecl uninstall memcached
    else
        echo "✘ Memcached not registered in PECL for PHP $PHP_VERSION."
    fi

    INI_FILE="/etc/php/$PHP_VERSION/mods-available/memcached.ini"
    if [ -f "$INI_FILE" ]; then
        rm -f "$INI_FILE"
        echo "✔ Removed $INI_FILE"
    fi

    CONF_D_DIR="/etc/php/$PHP_VERSION"
    for conf_file in $(find "$CONF_D_DIR" -type f -name "*memcached.ini"); do
        rm -f "$conf_file"
        echo "✔ Removed $conf_file"
    done

    EXT_DIR=$(/usr/bin/php$PHP_VERSION -i | grep '^extension_dir' | awk '{print $3}')
    if [ -f "$EXT_DIR/memcached.so" ]; then
        rm -f "$EXT_DIR/memcached.so"
        echo "✔ Removed $EXT_DIR/memcached.so"
    fi

    echo "✔ Cleanup done for PHP $PHP_VERSION."
}

# ----------------------------------------------------------------------------------#
#   Install Memcached extension using PECL for each PHP version                     #
# ----------------------------------------------------------------------------------#

install_memcached() {
    PHP_VERSION="$1"
    echo "DEBUG: NOW EXECUTING THE **NEW** MANUAL BUILD install_memcached function for PHP $PHP_VERSION"
    echo "Installing Memcached for PHP $PHP_VERSION..."

    PHP_BIN="/usr/bin/php$PHP_VERSION"
    PHP_CONFIG_BIN="/usr/bin/php-config$PHP_VERSION"
    PHPIZE_BIN="/usr/bin/phpize$PHP_VERSION"

    # Check if necessary PHP binaries exist
    if [ ! -x "$PHP_BIN" ]; then
        echo "DEBUG: PHP_BIN $PHP_BIN not found or not executable."
        echo "✘ PHP $PHP_VERSION binary not found ($PHP_BIN). Skipping installation."
        return 1
    fi

    if [ ! -x "$PHP_CONFIG_BIN" ]; then
        echo "DEBUG: PHP_CONFIG_BIN $PHP_CONFIG_BIN not found or not executable."
        echo "✘ php-config for PHP $PHP_VERSION not found ($PHP_CONFIG_BIN)."
        echo "  Make sure php$PHP_VERSION-dev is installed. Skipping installation."
        return 1
    fi

    if [ ! -x "$PHPIZE_BIN" ]; then
        echo "DEBUG: PHPIZE_BIN $PHPIZE_BIN not found or not executable."
        echo "✘ phpize for PHP $PHP_VERSION not found ($PHPIZE_BIN)."
        echo "  Make sure php$PHP_VERSION-dev is installed. Skipping installation."
        return 1
    fi

    # Create a temporary directory for building
    BUILD_DIR=$(mktemp -d)
    if [ -z "$BUILD_DIR" ]; then
        echo "✘ Failed to create temporary build directory."
        return 1
    fi
    CURRENT_DIR=$(pwd) # Save current directory

    echo "Changing to temporary directory $BUILD_DIR"
    cd "$BUILD_DIR" || { echo "✘ Failed to cd to $BUILD_DIR"; rm -rf "$BUILD_DIR"; return 1; }

    # Download and extract the Memcached PECL package
    echo "Downloading memcached PECL package..."
    if ! pecl download memcached; then
        echo "✘ Failed to download memcached package using pecl."
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi

    MEMCACHED_TGZ=$(find . -name 'memcached-*.tgz' -print -quit)
    if [ -z "$MEMCACHED_TGZ" ]; then
        echo "✘ Failed to find downloaded memcached tgz file."
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi

    echo "Extracting $MEMCACHED_TGZ..."
    tar -xzf "$MEMCACHED_TGZ"

    # Locate the extracted package directory
    PKG_DIR_NAME=$(basename "$MEMCACHED_TGZ" .tgz)
    EXTRACTED_PKG_DIR=""
    if [ -d "$PKG_DIR_NAME" ]; then
        EXTRACTED_PKG_DIR="$PKG_DIR_NAME"
    else
        FOUND_DIRS=( $(find . -maxdepth 1 -type d -name "memcached-*" -print) )
        if [ ${#FOUND_DIRS[@]} -eq 1 ]; then
            EXTRACTED_PKG_DIR="${FOUND_DIRS[0]}"
        elif [ ${#FOUND_DIRS[@]} -gt 1 ]; then
            echo "⚠ Multiple possible extracted directories found. Using the first one: ${FOUND_DIRS[0]}"
            EXTRACTED_PKG_DIR="${FOUND_DIRS[0]}"
        fi
    fi

    if [ -z "$EXTRACTED_PKG_DIR" ] || [ ! -d "$EXTRACTED_PKG_DIR" ]; then
        echo "✘ Could not determine extracted package directory for $MEMCACHED_TGZ. Contents of $BUILD_DIR:"
        ls -lA "$BUILD_DIR"
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi

    echo "Changing to package directory $EXTRACTED_PKG_DIR"
    cd "$EXTRACTED_PKG_DIR" || { echo "✘ Failed to cd to $EXTRACTED_PKG_DIR"; cd "$CURRENT_DIR"; rm -rf "$BUILD_DIR"; return 1; }

    # Build and install Memcached
    echo "DEBUG: About to run $PHPIZE_BIN"
    "$PHPIZE_BIN"
    if [ $? -ne 0 ]; then
        echo "DEBUG: $PHPIZE_BIN FAILED"
        echo "✘ $PHPIZE_BIN failed."
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi
    echo "DEBUG: $PHPIZE_BIN SUCCEEDED"

    echo "DEBUG: About to run ./configure --with-php-config=$PHP_CONFIG_BIN"
    ./configure --with-php-config="$PHP_CONFIG_BIN"
    if [ $? -ne 0 ]; then
        echo "DEBUG: ./configure FAILED"
        echo "✘ ./configure with $PHP_CONFIG_BIN failed."
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi
    echo "DEBUG: ./configure SUCCEEDED"

    echo "Running make..."
    make
    if [ $? -ne 0 ]; then
        echo "✘ make failed."
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi

    echo "Running sudo make install..."
    sudo make install
    if [ $? -ne 0 ]; then
        echo "✘ sudo make install failed."
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi

    # Clean up and verify installation
    echo "Cleaning up build directory..."
    cd "$CURRENT_DIR"
    rm -rf "$BUILD_DIR"

    EXT_DIR=$("$PHP_CONFIG_BIN" --extension-dir)
    if [ ! -f "$EXT_DIR/memcached.so" ]; then
        echo "✘ memcached.so not found in $EXT_DIR after manual build. Installation might have failed silently."
        return 1
    fi
    echo "✔ memcached.so found in $EXT_DIR."

    # Enable the extension
    INI_FILE_MODS_AVAIL="/etc/php/$PHP_VERSION/mods-available/memcached.ini"
    echo "extension=memcached.so" | sudo tee "$INI_FILE_MODS_AVAIL" > /dev/null
    echo "✔ Created/Updated $INI_FILE_MODS_AVAIL"

    for SAPI in cli fpm; do
        CONF_D_LINK_DIR="/etc/php/$PHP_VERSION/$SAPI/conf.d"
        TARGET_INI_SYMLINK="$CONF_D_LINK_DIR/20-memcached.ini"
        if [ -d "$CONF_D_LINK_DIR" ]; then
            sudo ln -sf "$INI_FILE_MODS_AVAIL" "$TARGET_INI_SYMLINK"
            echo "✔ Linked $TARGET_INI_SYMLINK to $INI_FILE_MODS_AVAIL"
        else
            echo "⚠ Directory $CONF_D_LINK_DIR not found for SAPI $SAPI. Skipping symlink."
        fi
    done

    # Restart PHP-FPM
    if systemctl list-units --type=service | grep -q "php$PHP_VERSION-fpm.service"; then
        sudo systemctl restart "php$PHP_VERSION-fpm"
        echo "✔ Restarted PHP-FPM for PHP $PHP_VERSION."
    else
        echo "ℹ PHP-FPM service for PHP $PHP_VERSION not found. Skipping restart."
    fi

    return 0
}

# ----------------------------------------------------------------------------------#
#   STEP 12: Configure Memcached settings for each PHP version                      #
# ----------------------------------------------------------------------------------#

configure_memcached() {
    PHP_VERSION=$1
    echo "Configuring memcached for PHP $PHP_VERSION..."

    sudo sed -i \
      -e '/^\s*memcached\.serializer\s*=/d'                    -e "/^\[memcached\]/a memcached.serializer = php" \
      -e '/^\s*memcached\.sess_prefix\s*=/d'                   -e "/^\[memcached\]/a memcached.sess_prefix = memc.sess.key." \
      -e '/^\s*memcached\.sess_binary\s*=/d'                   -e "/^\[memcached\]/a memcached.sess_binary = On" \
      -e '/^\s*memcached\.use_sasl\s*=/d'                      -e "/^\[memcached\]/a memcached.use_sasl = 0" \
      -e '/^\s*memcached\.sess_lock_wait_min\s*=/d'            -e "/^\[memcached\]/a memcached.sess_lock_wait_min = 150" \
      -e '/^\s*memcached\.sess_lock_wait_max\s*=/d'            -e "/^\[memcached\]/a memcached.sess_lock_wait_max = 150" \
      /etc/php/$PHP_VERSION/fpm/conf.d/20-memcached.ini
}

# Apply configuration for all PHP versions
for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
    configure_memcached "$PHP_VERSION"
done

# ----------------------------------------------------------------------------------#
#   STEP 13: Verify and handle Imagick installation                                 #
# ----------------------------------------------------------------------------------#

verify_and_handle_Imagick() {
    for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
        echo "DEBUG: Starting verification of Imagick for PHP $PHP_VERSION..." # Debug message
        echo "🔍 Checking Imagick for PHP $PHP_VERSION..."

        PHP_BIN="/usr/bin/php$PHP_VERSION"
        if [ ! -x "$PHP_BIN" ]; then
            echo "DEBUG: PHP binary $PHP_BIN not found or not executable. Skipping..." # Debug message
            echo "⚠ PHP $PHP_VERSION binary not found. Skipping."
            echo "---------------------------------------------"
            continue
        fi

        PECL_BIN="/usr/bin/pecl"
        if [ ! -x "$PECL_BIN" ]; then
            echo "DEBUG: PECL binary $PECL_BIN not found. Ensure php-pear is installed." # Debug message
            echo "✘ PECL not found. Install php-pear first."
            echo "---------------------------------------------"
            continue
        fi

        # Check if Imagick is installed for this PHP version
        if PHP_PEAR_PHP_BIN=$PHP_BIN $PECL_BIN list | grep -q 'imagick'; then
            echo "DEBUG: Imagick is installed for PHP $PHP_VERSION. Calling uninstall_Imagick..."
            echo "✔ Imagick is installed for PHP $PHP_VERSION. Uninstalling..."
            uninstall_Imagick "$PHP_VERSION"
        else
            echo "DEBUG: Imagick is NOT installed for PHP $PHP_VERSION. Ready for installation."
            echo "✘ Imagick is NOT installed for PHP $PHP_VERSION."
        fi

        # Install Imagick after verification/uninstallation
        echo "DEBUG: Calling install_imagick for PHP $PHP_VERSION..."
        echo "➡ Installing Imagick for PHP $PHP_VERSION..."
        install_imagick "$PHP_VERSION"

        echo "---------------------------------------------"
    done
}

# Call Imagick verification and installation
echo "DEBUG: Starting Imagick verification and installation..."
verify_and_handle_Imagick
echo "DEBUG: Finished Imagick verification and installation."

# ----------------------------------------------------------------------------------#
#   STEP 14: Install Imagick extension using PECL for each PHP version              #
# ----------------------------------------------------------------------------------#

install_imagick() {
    PHP_VERSION="$1" # Receive the PHP version as an argument
    echo "DEBUG: Starting install_imagick for PHP $PHP_VERSION..."
    
    # Define paths for PHP binaries
    echo "DEBUG: 11.1 - Defining PHP-related binary paths..."
    PHP_BIN="/usr/bin/php$PHP_VERSION"
    PHP_CONFIG_BIN="/usr/bin/php-config$PHP_VERSION"
    PHPIZE_BIN="/usr/bin/phpize$PHP_VERSION"
    echo "DEBUG: PHP_BIN = $PHP_BIN, PHP_CONFIG_BIN = $PHP_CONFIG_BIN, PHPIZE_BIN = $PHPIZE_BIN"

    # Verify existence of binaries
    echo "DEBUG: 11.2 - Verifying binaries for PHP $PHP_VERSION..."
    if [ ! -x "$PHP_BIN" ]; then
        echo "ERROR: PHP binary $PHP_BIN not found. Skipping installation for PHP $PHP_VERSION."
        return 1
    fi

    if [ ! -x "$PHP_CONFIG_BIN" ]; then
        echo "ERROR: php-config binary $PHP_CONFIG_BIN not found. Ensure php$PHP_VERSION-dev is installed."
        return 1
    fi

    if [ ! -x "$PHPIZE_BIN" ]; then
        echo "ERROR: phpize binary $PHPIZE_BIN not found. Ensure php$PHP_VERSION-dev is installed."
        return 1
    fi

    # Create a temporary directory for building
    echo "DEBUG: 11.3 - Creating a temporary build directory..."
    BUILD_DIR=$(mktemp -d)
    if [ -z "$BUILD_DIR" ]; then
        echo "ERROR: Failed to create a temporary build directory."
        return 1
    fi
    echo "DEBUG: Temporary build directory created at $BUILD_DIR"
    CURRENT_DIR=$(pwd)

    # Change to temporary directory
    echo "DEBUG: Changing to the temporary build directory: $BUILD_DIR"
    cd "$BUILD_DIR" || { echo "ERROR: Failed to cd to $BUILD_DIR"; rm -rf "$BUILD_DIR"; return 1; }

    # Download the Imagick PECL package
    echo "DEBUG: Downloading Imagick PECL package using pecl..."
    if ! pecl download imagick; then
        echo "ERROR: Failed to download Imagick package using PECL."
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi
    echo "DEBUG: Imagick package downloaded successfully."

    # Extract the downloaded package
    echo "DEBUG: Extracting the Imagick package..."
    IMAGICK_TGZ=$(find . -name 'imagick-*.tgz' -print -quit)
    if [ -z "$IMAGICK_TGZ" ]; then
        echo "ERROR: Failed to find the downloaded Imagick tgz file."
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi
    echo "DEBUG: Found Imagick package: $IMAGICK_TGZ"
    tar -xzf "$IMAGICK_TGZ"
    echo "DEBUG: Imagick package extracted."

    # Locate the extracted directory
    echo "DEBUG: Locating the extracted package directory..."
    PKG_DIR_NAME=$(basename "$IMAGICK_TGZ" .tgz)
    EXTRACTED_PKG_DIR=""
    if [ -d "$PKG_DIR_NAME" ]; then
        EXTRACTED_PKG_DIR="$PKG_DIR_NAME"
    else
        FOUND_DIRS=( $(find . -maxdepth 1 -type d -name "imagick-*" -print) )
        if [ ${#FOUND_DIRS[@]} -eq 1 ]; then
            EXTRACTED_PKG_DIR="${FOUND_DIRS[0]}"
        elif [ ${#FOUND_DIRS[@]} -gt 1 ]; then
            echo "WARNING: Multiple possible directories found. Using the first: ${FOUND_DIRS[0]}"
            EXTRACTED_PKG_DIR="${FOUND_DIRS[0]}"
        fi
    fi

    if [ -z "$EXTRACTED_PKG_DIR" ] || [ ! -d "$EXTRACTED_PKG_DIR" ]; then
        echo "ERROR: Could not determine the extracted package directory. Contents of $BUILD_DIR:"
        ls -lA "$BUILD_DIR"
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi
    echo "DEBUG: Located package directory: $EXTRACTED_PKG_DIR"

    # Change to the package directory
    echo "DEBUG: 11.8 - Changing to the package directory: $EXTRACTED_PKG_DIR"
    cd "$EXTRACTED_PKG_DIR" || { echo "ERROR: Failed to cd to $EXTRACTED_PKG_DIR"; cd "$CURRENT_DIR"; rm -rf "$BUILD_DIR"; return 1; }

    # Build and install Imagick
    echo "DEBUG: 11.9 - Building and installing Imagick..."
    echo "DEBUG: Running $PHPIZE_BIN..."
    "$PHPIZE_BIN"
    if [ $? -ne 0 ]; then
        echo "ERROR: $PHPIZE_BIN failed."
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi

    echo "DEBUG: Running ./configure --with-php-config=$PHP_CONFIG_BIN..."
    ./configure --with-php-config="$PHP_CONFIG_BIN"
    if [ $? -ne 0 ]; then
        echo "ERROR: ./configure failed with $PHP_CONFIG_BIN."
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi

    echo "DEBUG: Running make..."
    make
    if [ $? -ne 0 ]; then
        echo "ERROR: make failed."
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi

    echo "DEBUG: Running sudo make install..."
    sudo make install
    if [ $? -ne 0 ]; then
        echo "ERROR: sudo make install failed."
        cd "$CURRENT_DIR"
        rm -rf "$BUILD_DIR"
        return 1
    fi

    # Enable the extension and restart PHP-FPM
    echo "DEBUG: 11.10 - Enabling the Imagick extension and restarting PHP-FPM..."
    INI_FILE_MODS_AVAIL="/etc/php/$PHP_VERSION/mods-available/imagick.ini"
    echo "extension=imagick.so" | sudo tee "$INI_FILE_MODS_AVAIL" > /dev/null
    for SAPI in cli fpm; do
        CONF_D_LINK_DIR="/etc/php/$PHP_VERSION/$SAPI/conf.d"
        TARGET_INI_SYMLINK="$CONF_D_LINK_DIR/20-imagick.ini"
        if [ -d "$CONF_D_LINK_DIR" ]; then
            sudo ln -sf "$INI_FILE_MODS_AVAIL" "$TARGET_INI_SYMLINK"
            echo "DEBUG: Linked $TARGET_INI_SYMLINK to $INI_FILE_MODS_AVAIL"
        else
            echo "WARNING: Directory $CONF_D_LINK_DIR not found for SAPI $SAPI. Skipping symlink."
        fi
    done

    if systemctl list-units --type=service | grep -q "php$PHP_VERSION-fpm.service"; then
        echo "DEBUG: Restarting PHP-FPM service for PHP $PHP_VERSION..."
        sudo systemctl restart "php$PHP_VERSION-fpm"
        echo "✔ Restarted PHP-FPM for PHP $PHP_VERSION."
    else
        echo "WARNING: PHP-FPM service for PHP $PHP_VERSION not found. Skipping restart."
    fi

    # Cleanup
    echo "DEBUG: Cleaning up temporary build directory..."
    cd "$CURRENT_DIR"
    rm -rf "$BUILD_DIR"

    echo "✔ Imagick for PHP $PHP_VERSION installed successfully."
    return 0
}

# ----------------------------------------------------------------------------------#
#   STEP 15: Verify installed extensions for each PHP version                       #
# ----------------------------------------------------------------------------------#

verify_installed_extensions() {
    for PHP_VERSION in "${PHP_VERSIONS[@]}"; do
        echo "Verifying installed extensions for PHP $PHP_VERSION..."

        # Verifying Imagick
        if /usr/bin/php"$PHP_VERSION" -m | grep -q 'imagick'; then
            echo "✔ Imagick is installed for PHP $PHP_VERSION."
        else
            echo "✘ Imagick is NOT installed for PHP $PHP_VERSION."
        fi

        # Verifying Memcached
        if /usr/bin/php"$PHP_VERSION" -m | grep -q 'memcached'; then
            echo "✔ Memcached is installed for PHP $PHP_VERSION."
        else
            echo "✘ Memcached is NOT installed for PHP $PHP_VERSION."
        fi

        echo "---------------------------------------------"
    done
}
