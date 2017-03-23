var config = {
  environment: '__CARTO_ENV__',
  port: __WINDSHAFT_PORT__,
  host: '0.0.0.0',
  uv_threadpool_size: undefined,
  user_from_host: '^(.*)\\.localhost',
  base_url_templated: '(?:/api/v1/map/named|/user/:user/api/v1/map/named|/tiles/template)',
  base_url_detached: '(?:/api/v1/map|/user/:user/api/v1/map|/tiles/layergroup)',
  resources_url_templates: {
    http: 'http://{{=it.user}}.__CARTO_SESSION_DOMAIN__:{{=it.port}}/api/v1/map',
    https: 'http://__CARTO_SESSION_DOMAIN__:{{=it.port}}/user/{{=it.user}}/api/v1/map'
  },
  maxConnections: 128,
  maxUserTemplates: 1024,
  mapConfigTTL: 7200,
  socket_timeout: 600000,
  enable_cors: __CORS_ENABLED__,
  cache_enabled: false,
  log_format: ':req[X-Real-IP] :method :req[Host]:url :status :response-time ms -> :res[Content-Type] (:res[X-Tiler-Profiler])',
  log_filename: undefined,
  postgres_auth_user: 'development_cartodb_user_<%= user_id %>',
  postgres_auth_pass: '<%= user_password %>',
  postgres: {
    type: "postgis",
    user: '__DB_USER__',
    host: '__DB_HOST__',
    password: "public",
    port: 5432,
    extent: "-20037508.3,-20037508.3,20037508.3,20037508.3",
    row_limit: 65535,
    simplify_geometries: true,
    use_overviews: true,
    persist_connection: false,
    max_size: 500
  },
  mapnik_version: undefined,
  mapnik_tile_format: 'png8:m=h',
  statsd: {
    host: 'localhost',
    port: 8125,
    prefix: 'dev.',
    cacheDns: true
  },
  renderer: {
    cache_ttl: 60000,
    statsInterval: 5000,
    mapnik: {
      poolSize: 8,
      useCartocssWorkers: false,
      metatile: 2,
      metatileCache: {
        ttl: 0,
        deleteOnHit: false
      },
      formatMetatile: {
        png: 2,
        'grid.json': 1
      },
      bufferSize: 64,
      snapToGrid: false,
      clipByBox2d: false, // this requires postgis >=2.2 and geos >=3.5
      limits: {
        render: 0,
        cacheOnTimeout: true
      },
      geojson: {
        dbPoolParams: {
          size: 16,
          idleTimeout: 3000,
          reapInterval: 1000
        },
        clipByBox2d: false, // this requires postgis >=2.2 and geos >=3.5
        removeRepeatedPoints: false // this requires postgis >=2.2
      }
    },
    http: {
      timeout: 2000, // the timeout in ms for a http tile request
      proxy: undefined, // the url for a proxy server
      whitelist: [ // the whitelist of urlTemplates that can be used
        '.*', // will enable any URL
        'http://{s}.example.com/{z}/{x}/{y}.png'
      ],
      fallbackImage: {
        type: 'fs', // 'fs' and 'url' supported
        src: __dirname + '/../../assets/default-placeholder.png'
      }
    },
    torque: {
      dbPoolParams: {
        size: 16,
        idleTimeout: 3000,
        reapInterval: 1000
      }
    }
  },
  analysis: {
    batch: {
      inlineExecution: false,
      endpoint: 'http://127.0.0.1:8080/api/v2/sql/job',
      hostHeaderTemplate: '{{=it.username}}.__CARTO_SESSION_DOMAIN__'
    },
    logger: {
      filename: '/tmp/analysis.log'
    },
    limits: {
      moran: {
        timeout: 120000,
        maxNumberOfRows: 1e5
      },
      cpu2x: {
        timeout: 60000
      }
    }
  },
  millstone: {

    cache_basedir: '/tmp/cdb-tiler-dev/millstone-dev'
  },
  redis: {
    host: '__REDIS_HOST__',
    port: __REDIS_PORT__,
    max: 50,
    returnToHead: true, // defines the behaviour of the pool: false => queue, true => stack
    idleTimeoutMillis: 1, // idle time before dropping connection
    reapIntervalMillis: 1, // time between cleanups
    slowQueries: {
      log: true,
      elapsedThreshold: 200
    },
    slowPool: {
      log: true, // whether a slow acquire must be logged or not
      elapsedThreshold: 25 // the threshold to determine an slow acquire must be reported or not
    },
    emitter: {
      statusInterval: 5000 // time, in ms, between each status report is emitted from the pool, status is sent to statsd
    },
    unwatchOnRelease: false, // Send unwatch on release, see http://github.com/CartoDB/Windshaft-cartodb/issues/161
    noReadyCheck: true // Check `no_ready_check` at https://github.com/mranney/node_redis/tree/v0.12.1#overloading
  },
  httpAgent: {
    keepAlive: true,
    keepAliveMsecs: 1000,
    maxSockets: 25,
    maxFreeSockets: 256
  },
  varnish: {
    host: 'localhost',
    port: 6082, // the por for the telnet interface where varnish is listening to
    http_port: 6081, // the port for the HTTP interface where varnish is listening to
    purge_enabled: false, // whether the purge/invalidation mechanism is enabled in varnish or not
    secret: 'xxx',
    ttl: 86400,
    layergroupTtl: 86400 // the max-age for cache-control header in layergroup responses
  },
  fastly: {
    enabled: false,
    apiKey: 'wadus_api_key',
    serviceId: 'wadus_service_id'
  },
  useProfiler: true,
  health: {
    enabled: false,
    username: 'localhost',
    z: 0,
    x: 0,
    y: 0
  },
  disabled_file: 'pids/disabled',
  enabledFeatures: {
    onTileErrorStrategy: true,
    cdbQueryTablesFromPostgres: true,
    layerMetadata: true
  }
};

module.exports = config;
