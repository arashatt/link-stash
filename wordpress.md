Here’s a Perl script to automate the process of downloading, extracting, and installing WordPress. The script assumes that you have the necessary permissions on your system to perform the installation (e.g., running on a local server, or you have proper permissions on the web server).

**Steps Covered in the Perl Script:**
1. Download WordPress.
2. Extract the WordPress archive.
3. Move files to the web directory (e.g., `/var/www/html`).
4. Set proper permissions on files.
5. Create a database for WordPress.

### Perl Script for Installing WordPress

Before you start, ensure that:
- You have `wget` or `curl` installed on your system to download files.
- You have MySQL installed and ready for the WordPress database.
- The necessary Perl modules are installed (`DBI` for database interaction, `File::Copy` for file operations, and `Archive::Extract` for extracting files).

```perl
#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use File::Copy;
use File::Path qw(make_path);
use Archive::Extract;

# Define the variables
my $wordpress_url = "https://wordpress.org/latest.tar.gz";
my $download_path = "/tmp/latest.tar.gz";         # Temporary location to download WordPress
my $web_root = "/var/www/html";                   # Destination where WordPress should be installed
my $db_name = "wordpress_db";                     # Database name
my $db_user = "wordpress_user";                   # Database user
my $db_pass = "password";                         # Database password
my $db_host = "localhost";                        # Database host

# Download the latest WordPress
print "Downloading WordPress...\n";
system("wget -O $download_path $wordpress_url") == 0 or die "Failed to download WordPress\n";

# Extract the WordPress archive
print "Extracting WordPress...\n";
my $archive = Archive::Extract->new(archive => $download_path);
my $extract_path = "/tmp";
$archive->extract(to => $extract_path) or die "Failed to extract WordPress\n";

# Move extracted files to the web root
my $wordpress_dir = "$extract_path/wordpress";
if (-d $wordpress_dir) {
    print "Moving WordPress files to $web_root...\n";
    system("cp -r $wordpress_dir/* $web_root") == 0 or die "Failed to move WordPress files\n";
} else {
    die "WordPress directory not found after extraction\n";
}

# Set the correct permissions
print "Setting permissions...\n";
system("chown -R www-data:www-data $web_root") == 0 or die "Failed to set ownership\n";
system("chmod -R 755 $web_root") == 0 or die "Failed to set permissions\n";

# Create MySQL database and user for WordPress
print "Creating MySQL database...\n";
my $dbh = DBI->connect("DBI:mysql:;host=$db_host", "root", "")
    or die "Could not connect to MySQL: $DBI::errstr\n";

# Execute SQL statements to create the database and user
my $sql = <<"END_SQL";
CREATE DATABASE IF NOT EXISTS $db_name;
CREATE USER IF NOT EXISTS '$db_user'\@'$db_host' IDENTIFIED BY '$db_pass';
GRANT ALL PRIVILEGES ON $db_name.* TO '$db_user'\@'$db_host';
FLUSH PRIVILEGES;
END_SQL

for my $statement (split /;/, $sql) {
    next unless $statement =~ /\S/;
    $dbh->do($statement) or warn "SQL error: " . $dbh->errstr;
}

$dbh->disconnect;

print "WordPress has been installed. You can now complete the setup through the web interface.\n";
```

### Explanation of the Script:

1. **Download WordPress:**
   The script uses `wget` to download the latest WordPress tarball into `/tmp`.

2. **Extract WordPress:**
   It then extracts the downloaded tarball using `Archive::Extract` to `/tmp`.

3. **Move WordPress to Web Root:**
   The script moves the WordPress files from the extraction directory to the web root (`/var/www/html`).

4. **Set File Permissions:**
   Appropriate ownership (`www-data`, the default user for Apache/Nginx) and permissions (`755`) are applied to the WordPress files.

5. **Create MySQL Database:**
   The script connects to MySQL, creates a new database, and assigns a user with full privileges to the new database.

### Prerequisites:

- Install the required Perl modules:
  ```bash
  cpan Archive::Extract DBI
  ```

- Ensure that you have `wget` and `MySQL` installed and running.

- You might need to run the script with root privileges to ensure that it can write to `/var/www/html` and perform system operations.

```bash
sudo perl install_wordpress.pl
```

### Final Steps:

Once the script completes, you can finish the installation via the WordPress web installer:
1. Open your browser and navigate to `http://localhost`.
2. Complete the WordPress installation by entering the database information (database name, user, password, etc.).
3. Follow the remaining on-screen instructions to finalize the installation.

This script simplifies WordPress installation but can be further enhanced depending on your specific requirements, such as configuring `.htaccess` or setting up custom themes/plugins.