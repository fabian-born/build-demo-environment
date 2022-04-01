cloudprovidername: "${CLOUDPROVIDER}"
clustername: "${K8SCLUSTER}"
storageclassname: "netapp-anf-perf-standard"
manager_cluster_body: '{
         "defaultStorageClass": "{{ (storageclass_id) }}" ,
         "id": "{{ (cluster_id) }}",
         "type": "application/astra-managedCluster",
         "version": "1.0",
      }'
astra_api_token: "JT6V-CRqsGJTUQuQnoO3NQ00YnumTCEo97kcNOaA4HU="
astra_account_id: "876a0cf3-623b-458b-83d6-62cfba1a7c50"
astra_api_endpoint: "demo.astra.netapp.io:443"
run_debug: true
