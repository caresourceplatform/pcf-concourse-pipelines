#!/bin/bash

if [[ $DEBUG == true ]]; then
  set -ex
else
  set -e
fi

chmod +x om-cli/om-linux
OM_CMD=./om-cli/om-linux

chmod +x ./jq/jq-linux64
JQ_CMD=./jq/jq-linux64

export 

properties_config=$($JQ_CMD -n \
  --arg apns_proxy "${APNS_PROXY:-"None"}" \
  --arg apns_proxy_socks_host "${APNS_PROXY_SOCKS_HOST}" \
  --arg apns_proxy_socks_port "${APNS_PROXY_SOCKS_PORT}" \
  --arg baidu_proxy "${BAIDU_PROXY:-"None"}" \
  --arg baidu_proxy_http_host "${BAIDU_PROXY_HTTP_HOST}" \
  --arg baidu_proxy_http_port "${BAIDU_PROXY_HTTP_PORT}" \
  --arg baidu_proxy_socks_host "${BAIDU_PROXY_SOCKS_HOST}" \
  --arg baidu_proxy_socks_port "${BAIDU_PROXY_SOCKS_PORT}" \
  --arg create_platform_whitelist "${CREATE_PLATFORM_WHITELIST}" \
  --arg deployment_type "${DEPLOYMENT_TYPE:-"Development"}" \
  --arg fcm_proxy "${FCM_PROXY:-"None"}" \
  --arg fcm_proxy_http_host "${FCM_PROXY_HTTP_HOST}" \
  --arg fcm_proxy_http_port "${FCM_PROXY_HTTP_PORT}" \
  --arg fcm_proxy_socks_host "${FCM_PROXY_SOCKS_HOST}" \
  --arg fcm_proxy_socks_port "${FCM_PROXY_SOCKS_PORT}" \
  --arg gcm_proxy "${GCM_PROXY:-"None"}" \
  --arg gcm_proxy_http_host "${GCM_PROXY_HTTP_HOST}" \
  --arg gcm_proxy_http_port "${GCM_PROXY_HTTP_PORT}" \
  --arg gcm_proxy_socks_host "${GCM_PROXY_SOCKS_HOST}" \
  --arg gcm_proxy_socks_port "${GCM_PROXY_SOCKS_PORT}" \
  --arg mysql "${MYSQL:-"MySQL Service"}" \
  --arg mysql_external_database "${MYSQL_EXTERNAL_DATABASE}" \
  --arg mysql_external_host "${MYSQL_EXTERNAL_HOST}" \
  --arg mysql_external_password "${MYSQL_EXTERNAL_PASSWORD}" \
  --arg mysql_external_port "${MYSQL_EXTERNAL_PORT}" \
  --arg mysql_external_username "${MYSQL_EXTERNAL_USERNAME}" \
  --arg mysql_internal_service_plan "${MYSQL_INTERNAL_SERVICE_PLAN:-"push"}" \
  --arg redis_analytics "${REDIS_ANALYTICS:-"Redis Service"}" \
  --arg redis_analytics_external_db_number "${REDIS_ANALYTICS_EXTERNAL_DB_NUMBER:-0}" \
  --arg redis_analytics_external_host "${REDIS_ANALYTICS_EXTERNAL_HOST}" \
  --arg redis_analytics_external_password "${REDIS_ANALYTICS_EXTERNAL_PASSWORD}" \
  --arg redis_analytics_external_port "${REDIS_ANALYTICS_EXTERNAL_PORT}" \
  --arg redis_analytics_internal_service_plan "${REDIS_ANALYTICS_INTERNAL_SERVICE_PLAN:-"dedicated-vm"}" \
  --arg push_push_notifications_api_db_encryption_key "${PUSH_PUSH_NOTIFICATIONS_API_DB_ENCRYPTION_KEY}" \
  --arg push_push_notifications_default_system_tenant_name "${PUSH_PUSH_NOTIFICATIONS_DEFAULT_SYSTEM_TENANT_NAME}" \
'{
  ".properties.gcm_proxy": {
    "value": $gcm_proxy
  },
  ".properties.fcm_proxy": {
    "value": $fcm_proxy
  },
  ".properties.baidu_proxy": {
    "value": $baidu_proxy
  },
  ".properties.apns_proxy": {
    "value": $apns_proxy
  },
  ".properties.deployment_type": {
    "value": $deployment_type
  },
  ".properties.create_platform_whitelist": {
    "value": ($create_platform_whitelist | split(",") )
  },
  ".push-push-notifications.api_db_encryption_key": {
    "value": {
      "secret": $push_push_notifications_api_db_encryption_key
    }
  },
  ".push-push-notifications.default_system_tenant_name": {
    "value": $push_push_notifications_default_system_tenant_name
  },
  ".properties.mysql": {
    "value": $mysql
  },
    ".properties.redis_analytics": {
    "value": $redis_analytics
  }
}
+
if $mysql=="External" then{
  ".properties.mysql.external.host": {
    "value": $mysql_external_host
  },
  ".properties.mysql.external.port": {
    "value": $mysql_external_port
  },
  ".properties.mysql.external.username": {
    "value": $mysql_external_username
  },
  ".properties.mysql.external.password": {
    "value":{
      "secret": $mysql_external_password
      }
  },
  ".properties.mysql.external.database": {
    "value": $mysql_external_database
  }
}
else {
 ".properties.mysql.internal.service_plan": {
    "value": $mysql_internal_service_plan
  }
}
end
+
if $redis_analytics=="External" then{
  ".properties.redis_analytics.external.host": {
    "value": $redis_analytics_external_host
  },
  ".properties.redis_analytics.external.port": {
    "value": $redis_analytics_external_port
  },
  ".properties.redis_analytics.external.password": {
    "value":{
      "secret":$redis_analytics_external_password
      }
  },
  ".properties.redis_analytics.external.db_number": {
    "value": $redis_analytics_external_db_number
  }
}
else {  
  ".properties.redis_analytics.internal.service_plan": {
    "value": $redis_analytics_internal_service_plan
  }
}
end
+
if $gcm_proxy== "HTTP" then {
    ".properties.gcm_proxy.http.host": {
    "value": $gcm_proxy_http_host
  },
  ".properties.gcm_proxy.http.port": {
    "value": $gcm_proxy_http_port
  }
}
elif $gcm_proxy== "SOCKS" then {
  ".properties.gcm_proxy.socks.host": {
    "value": $gcm_proxy_socks_host
  },
  ".properties.gcm_proxy.socks.port": {
    "value": $gcm_proxy_socks_port
  }
}
else .
end
+
if $fcm_proxy== "HTTP" then {
   ".properties.fcm_proxy.http.host": {
    "value": $fcm_proxy_http_host
  },
  ".properties.fcm_proxy.http.port": {
    "value": $fcm_proxy_http_port
  }
}
elif $fcm_proxy== "SOCKS" then {
  ".properties.fcm_proxy.socks.host": {
    "value": $fcm_proxy_socks_host
  },
  ".properties.fcm_proxy.socks.port": {
    "value": $fcm_proxy_socks_port
  }
}
else .
end
+
if $baidu_proxy== "HTTP" then {
  ".properties.baidu_proxy.http.host": {
    "value": $baidu_proxy_http_host
  },
  ".properties.baidu_proxy.http.port": {
    "value": $baidu_proxy_http_port
  }
}
elif $baidu_proxy== "SOCKS" then {
   ".properties.baidu_proxy.socks.host": {
    "value": $baidu_proxy_socks_host
  },
  ".properties.baidu_proxy.socks.port": {
    "value": $baidu_proxy_socks_port
  }
}
else .
end
+
if $apns_proxy== "SOCKS" then {
  
  ".properties.apns_proxy.socks.host": {
    "value": $apns_proxy_socks_host
  },
  ".properties.apns_proxy.socks.port": {
    "value": $apns_proxy_socks_port
  }
}
else .
end
'
)

echo $properties_config

resources_config="{
  \"push-push-notifications\": {\"instances\": ${PUSH_PUSH_NOTIFICATIONS_INSTANCES:-1}, \"instance_type\": { \"id\": \"${PUSH_PUSH_NOTIFICATIONS_INSTANCE_TYPE:-micro}\"}}
  }"
#\"delete-push-notifications\": {\"instances\": ${DELETE_PUSH_NOTIFICATIONS_INSTANCES:-1}, \"instance_type\": { \"id\": \"${DELETE_PUSH_NOTIFICATIONS_INSTANCE_TYPE:-micro}\"}}

echo $resources_config

network_config=$($JQ_CMD -n \
  --arg network_name "$NETWORK_NAME" \
  --arg other_azs "$OTHER_AZS" \
  --arg singleton_az "$SINGLETON_JOBS_AZ" \
  --arg service_network_name "$SERVICE_NETWORK_NAME" \
'
  {
    "network": {
      "name": $network_name
    },
    "other_availability_zones": ($other_azs | split(",") | map({name: .})),
    "singleton_availability_zone": {
      "name": $singleton_az
    },
    "service_network": {
      "name": $service_network_name
    }
  }
'
)

echo $network_config

$OM_CMD \
  --target https://$OPS_MGR_HOST \
  --username "$OPS_MGR_USR" \
  --password "$OPS_MGR_PWD" \
  --skip-ssl-validation \
  configure-product \
  --product-name "$PRODUCT_IDENTIFIER" \
  --product-properties "$properties_config" \
  --product-network "$network_config" \
  --product-resources "$resources_config"
