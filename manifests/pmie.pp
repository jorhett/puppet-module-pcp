# Define: pcp::pmie: See README.md for documentation
define pcp::pmie (
  Enum['present', 'absent'] $ensure             = 'present',
  String $hostname                              = 'LOCALHOSTNAME',
  Boolean $socks                                = false,
  String $log_file                              = 'PCP_LOG_DIR/pmie/LOCALHOSTNAME/pmie.log',
  String $args                                  = '',
  Optional[Stdlib::Absolutepath] $config_path   = undef,
  Optional[String] $config_content              = undef,
  Optional[String] $config_source               = undef,
) {

  include pcp

  Class['pcp::install'] -> Pcp::Pmie[$title]

  if $socks {
    $_socks = 'y'
  } else {
    $_socks = 'n'
  }

  if $config_path {
    $_args = "${args} -c ${config_path}"
  } else {
    $_args = $args
  }

  $_pmie_config_path = "/etc/pcp/pmie/control.d/${name}"
  $_line = "#This file is managed by Puppet\n${hostname} ${_socks} ${log_file} ${_args}\n"

  file { "pmie-${name}":
    ensure  => $ensure,
    path    => $_pmie_config_path,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $_line,
    notify  => Service['pmie'],
  }

  if $config_path {
    file { "pmie-${name}-config":
      ensure  => $ensure,
      path    => $config_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $config_content,
      source  => $config_source,
      notify  => Service['pmie'],
      before  => File["pmie-${name}"],
    }
  }

}
