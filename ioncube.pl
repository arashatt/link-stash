#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;

# Variables
my $php_version = `php -r 'echo PHP_VERSION;'`;   # Get PHP version
chomp($php_version);
my $arch = `uname -m`;    # Get system architecture
chomp($arch);

# Mapping the architecture
my $arch_map = {
    'x86_64' => 'x86-64',
    'i686'   => 'x86',
};

if (!exists $arch_map->{$arch}) {
    die "Unsupported architecture: $arch\n";
}

my $ioncube_url = "https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_$arch_map->{$arch}.tar.gz";
my $download_path = "/tmp/ioncube_loaders.tar.gz";
my $extract_path = "/tmp/ioncube";

# Step 1: Download ionCube Loader
print "Downloading ionCube Loader...\n";
getstore($ioncube_url, $download_path) or die "Failed to download ionCube Loader\n";

# Step 2: Extract ionCube Loader
print "Extracting ionCube Loader...\n";
system("mkdir -p $extract_path");
system("tar -xzf $download_path -C $extract_path");

# Step 3: Find the correct ionCube loader for your PHP version
my $loader_file = "$extract_path/ioncube/ioncube_loader_lin_" . substr($php_version, 0, 3) . ".so";

if (-e $loader_file) {
    print "Found ionCube loader for PHP version $php_version\n";
} else {
    die "ionCube loader for PHP version $php_version not found\n";
}

# Step 4: Find the PHP extensions directory
my $php_ext_dir = `php -i | grep ^extension_dir`;
$php_ext_dir =~ s/extension_dir => //g;
chomp($php_ext_dir);

if (!$php_ext_dir) {
    die "Failed to determine PHP extension directory\n";
}

# Step 5: Copy ionCube Loader to the extensions directory
print "Copying ionCube loader to PHP extensions directory...\n";
system("cp $loader_file $php_ext_dir") == 0 or die "Failed to copy ionCube loader to PHP extensions directory\n";

# Step 6: Modify php.ini to load ionCube
my $php_ini = `php --ini | grep Loaded`;
$php_ini =~ s/Loaded Configuration File: //g;
chomp($php_ini);

if (!$php_ini) {
    die "Failed to determine php.ini file\n";
}

print "Adding ionCube loader to php.ini...\n";
open my $fh, '>>', $php_ini or die "Failed to open php.ini: $!\n";
print $fh "\n; Enable ionCube Loader\nzend_extension = $php_ext_dir/ioncube_loader_lin_" . substr($php_version, 0, 3) . ".so\n";
close $fh;

# Step 7: Restart web server
print "Restarting web server...\n";
system("service apache2 restart") == 0 or die "Failed to restart Apache\n";

print "ionCube Loader installed successfully!\n";