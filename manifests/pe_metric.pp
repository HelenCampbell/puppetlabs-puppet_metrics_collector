define pe_metric_curl_cron_jobs::pe_metric (
  Enum['absent', 'present'] $metric_ensure = 'present',
  String                    $output_dir,
  String                    $scripts_dir,
  String                    $metrics_type  = $title,
  Array[String]             $hosts         = [ '127.0.0.1' ],
  String                    $cron_minute   = '*/5',
  Integer                   $retention_days = 3,
) {

  $metrics_output_dir = "${output_dir}/${metrics_type}"

  file { $metrics_output_dir :
    ensure => directory,
  }

  $script_file_name = "${scripts_dir}/${metrics_type}_metrics.sh"

  file { $script_file_name :
    ensure  => $metric_ensure,
    content => epp("pe_metric_curl_cron_jobs/${metrics_type}_metrics.sh.epp",
                  { 'output_dir' => $metrics_output_dir,
                    'hosts'      => $hosts,
                  }),
    mode    => '0744',
  }

  cron { "${metrics_type}_metrics_collection" :
    ensure  => $metric_ensure,
    command => $script_file_name,
    user    => 'root',
    minute  => $cron_minute,
  }

  cron { "${metrics_type}_metrics_tidy" :
    ensure  => $metric_ensure,
    command => epp("pe_metric_curl_cron_jobs/find_cron.epp",
                  { 'output_dir'     => $metrics_output_dir,
                    'retention_days' => $retention_days,
                  }),
    user    => 'root',
    hour    => '2',
  }
}
