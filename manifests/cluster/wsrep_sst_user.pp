# @summary Manage one wsrep_sst_auth user
# 
# This user is used to sync between cluster nodes and thus needs root like access to everything.
#
# @param wsrep_sst_password
# @param wsrep_sst_user
# @param wsrep_sst_user_tls_options
# @param wsrep_sst_user_grant_options
# @param wsrep_sst_user_privileges
#
define mariadb::cluster::wsrep_sst_user (
  String $wsrep_sst_password,
  String $wsrep_sst_user                      = $name,
  Array[String] $wsrep_sst_user_tls_options   = undef,
  Array[String] $wsrep_sst_user_grant_options = undef,
  Array[String] $wsrep_sst_user_privileges    = [
    'RELOAD',
    'PROCESS',
    'LOCK TABLES',
    'BINLOG MONITOR',
  ],
) {
  mysql_user { $wsrep_sst_user:
    ensure        => present,
    password_hash => mysql::password($wsrep_sst_password),
    tls_options   => $wsrep_sst_user_tls_options,
    require       => Class['mysql::server::root_password'],
  }

  -> mysql_grant { "${wsrep_sst_user}/*.*":
    ensure     => present,
    user       => $wsrep_sst_user,
    table      => '*.*',
    privileges => $wsrep_sst_user_privileges,
    options    => $wsrep_sst_user_grant_options,
  }
}
