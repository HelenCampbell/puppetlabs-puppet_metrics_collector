class pe_metric_curl_cron_jobs::puppetdb (
  Integer       $collection_frequency = $::pe_metric_curl_cron_jobs::collection_frequency,
  Integer       $retention_days       = $::pe_metric_curl_cron_jobs::retention_days,
  String        $metrics_ensure       = $::pe_metric_curl_cron_jobs::puppetdb_metrics_ensure,
  Array[String] $hosts                = $::pe_metric_curl_cron_jobs::puppetdb_hosts,
  Integer       $port                 = $::pe_metric_curl_cron_jobs::puppetdb_port,
) {
  Pe_metric_curl_cron_jobs::Pe_metric {
    output_dir     => $::pe_metric_curl_cron_jobs::output_dir,
    scripts_dir    => $::pe_metric_curl_cron_jobs::scripts_dir,
    cron_minute    => "*/${collection_frequency}",
    retention_days => $retention_days,
  }

  $activemq_metrics = [
    { 'name' => 'amq_metrics',
      'url'  => 'org.apache.activemq:type=Broker,brokerName=localhost,destinationType=Queue,destinationName=puppetlabs.puppetdb.commands' }
  ]

  $base_metrics = [
    { 'name' => 'global_command-parse-time',
      'url'  => 'puppetlabs.puppetdb.mq%3Aname%3Dglobal.command-parse-time' },
    { 'name' => 'global_discarded',
      'url'  => 'puppetlabs.puppetdb.mq%3Aname%3Dglobal.discarded' },
    { 'name' => 'global_fatal',
      'url'  => 'puppetlabs.puppetdb.mq%3Aname%3Dglobal.fatal' },
    { 'name' => 'global_generate-retry-message-time',
      'url'  => 'puppetlabs.puppetdb.mq%3Aname%3Dglobal.generate-retry-message-time' },
    { 'name' => 'global_message-persistence-time',
      'url'  => 'puppetlabs.puppetdb.mq%3Aname%3Dglobal.message-persistence-time' },
    { 'name' => 'global_retried',
      'url'  => 'puppetlabs.puppetdb.mq%3Aname%3Dglobal.retried' },
    { 'name' => 'global_retry-counts',
      'url'  => 'puppetlabs.puppetdb.mq%3Aname%3Dglobal.retry-counts' },
    { 'name' => 'global_retry-persistence-time',
      'url'  => 'puppetlabs.puppetdb.mq%3Aname%3Dglobal.retry-persistence-time' },
    { 'name' => 'global_seen',
      'url'  => 'puppetlabs.puppetdb.mq%3Aname%3Dglobal.seen' },
    { 'name' => 'global_processed',
      'url'  => 'puppetlabs.puppetdb.mq%3Aname%3Dglobal.processed' },
    { 'name' => 'global_processing-time',
      'url'  => 'puppetlabs.puppetdb.mq%3Aname%3Dglobal.processing-time' },
  ]

  $storage_metrics = [
    { 'name' => 'storage_add-edges',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dadd-edges' },
    { 'name' => 'storage_add-resources',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dadd-resources' },
    { 'name' => 'storage_catalog-hash',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dcatalog-hash' },
    { 'name' => 'storage_catalog-hash-match-time',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dcatalog-hash-match-time' },
    { 'name' => 'storage_catalog-hash-miss-time',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dcatalog-hash-miss-time' },
    { 'name' => 'storage_gc-catalogs-time',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dgc-catalogs-time' },
    { 'name' => 'storage_gc-environments-time',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dgc-environments-time' },
    { 'name' => 'storage_gc-fact-paths',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dgc-fact-paths' },
    { 'name' => 'storage_gc-params-time',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dgc-params-time' },
    { 'name' => 'storage_gc-report-statuses',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dgc-report-statuses' },
    { 'name' => 'storage_gc-time',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dgc-time' },
    { 'name' => 'storage_new-catalog-time',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dnew-catalog-time' },
    { 'name' => 'storage_new-catalogs',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dnew-catalogs' },
    { 'name' => 'storage_replace-catalog-time',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dreplace-catalog-time' },
    { 'name' => 'storage_replace-facts-time',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dreplace-facts-time' },
    { 'name' => 'storage_resource-hashes',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dresource-hashes' },
    { 'name' => 'storage_store-report-time',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dstore-report-time' },
  ]

  #TODO: Track these on a less frequent cadence because they are slow to run
  $storage_metrics_db_queries = [
    { 'name' => 'storage_catalog-volitilty',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dcatalog-volitilty' },
    { 'name' => 'storage_duplicate-catalogs',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dduplicate-catalogs' },
    { 'name' => 'storage_duplicate-pct',
      'url'  => 'puppetlabs.puppetdb.storage%3Aname%3Dduplicate-pct' },
  ]

  $numbers = $::pe_server_version ? {
    /^2015.2/     => {'catalogs' => 6, 'facts' => 4, 'reports' => 6},
    /^2015.3/     => {'catalogs' => 7, 'facts' => 4, 'reports' => 6},
    /^2016.(1|2)/ => {'catalogs' => 8, 'facts' => 4, 'reports' => 7},
    /^2016.(4|5)/ => {'catalogs' => 9, 'facts' => 5, 'reports' => 8},
    /^2017.(1|2)/ => {'catalogs' => 9, 'facts' => 5, 'reports' => 8},
    default       => {'catalogs' => 9, 'facts' => 5, 'reports' => 8},
  }

  $version_specific_metrics = [
    { 'name' => 'replace_catalog_retried',
      'url'  => "puppetlabs.puppetdb.mq%3Aname%3Dreplace+catalog.${numbers['catalogs']}.retried" },
    { 'name' => 'replace_catalog_retry_counts',
      'url'  => "puppetlabs.puppetdb.mq%3Aname%3Dreplace+catalog.${numbers['catalogs']}.retry-counts" },
    { 'name' => 'replace_facts_retried',
      'url'  => "puppetlabs.puppetdb.mq%3Aname%3Dreplace+facts.${numbers['facts']}.retried" },
    { 'name' => 'replace_facts_retry_counts',
      'url'  => "puppetlabs.puppetdb.mq%3Aname%3Dreplace+facts.${numbers['facts']}.retry-counts" },
    { 'name' => 'store_report_retried',
      'url'  => "puppetlabs.puppetdb.mq%3Aname%3Dstore+report.${numbers['reports']}.retried" },
    { 'name' => 'store_reports_retry_counts',
      'url'  => "puppetlabs.puppetdb.mq%3Aname%3Dstore+report.${numbers['reports']}.retry-counts" },
  ]

  $connection_pool_metrics = [
    { 'name' => 'PDBReadPool_pool_ActiveConnections',
      'url'  => 'puppetlabs.puppetdb.database%3Aname%3DPDBReadPool.pool.ActiveConnections' },
    { 'name' => 'PDBReadPool_pool_IdleConnections',
      'url'  => 'puppetlabs.puppetdb.database%3Aname%3DPDBReadPool.pool.IdleConnections' },
    { 'name' => 'PDBReadPool_pool_PendingConnections',
      'url'  => 'puppetlabs.puppetdb.database%3Aname%3DPDBReadPool.pool.PendingConnections' },
    { 'name' => 'PDBReadPool_pool_TotalConnections',
      'url'  => 'puppetlabs.puppetdb.database%3Aname%3DPDBReadPool.pool.TotalConnections' },
    { 'name' => 'PDBReadPool_pool_Usage',
      'url'  => 'puppetlabs.puppetdb.database%3Aname%3DPDBReadPool.pool.Usage' },
    { 'name' => 'PDBReadPool_pool_Wait',
      'url'  => 'puppetlabs.puppetdb.database%3Aname%3DPDBReadPool.pool.Wait' },
    { 'name' => 'PDBWritePool_pool_ActiveConnections',
      'url'  => 'puppetlabs.puppetdb.database%3Aname%3DPDBWritePool.pool.ActiveConnections' },
    { 'name' => 'PDBWritePool_pool_IdleConnections',
      'url'  => 'puppetlabs.puppetdb.database%3Aname%3DPDBWritePool.pool.IdleConnections' },
    { 'name' => 'PDBWritePool_pool_PendingConnections',
      'url'  => 'puppetlabs.puppetdb.database%3Aname%3DPDBWritePool.pool.PendingConnections' },
    { 'name' => 'PDBWritePool_pool_TotalConnections',
      'url'  => 'puppetlabs.puppetdb.database%3Aname%3DPDBWritePool.pool.TotalConnections' },
    { 'name' => 'PDBWritePool_pool_Usage',
      'url'  => 'puppetlabs.puppetdb.database%3Aname%3DPDBWritePool.pool.Usage' },
    { 'name' => 'PDBWritePool_pool_Wait',
      'url'  => 'puppetlabs.puppetdb.database%3Aname%3DPDBWritePool.pool.Wait' },
  ]

  $additional_metrics = $::pe_server_version ? {
    /^2015./ => $activemq_metrics,
    /^2016./ => $activemq_metrics + $base_metrics + $storage_metrics + $connection_pool_metrics + $version_specific_metrics,
    default  => $base_metrics + $storage_metrics + $connection_pool_metrics + $version_specific_metrics,
  }

  pe_metric_curl_cron_jobs::pe_metric { 'puppetdb' :
    metric_ensure => $metrics_ensure,
    hosts         => $hosts,
    metrics_port  => $port,
    additional_metrics => $additional_metrics,
  }
}
