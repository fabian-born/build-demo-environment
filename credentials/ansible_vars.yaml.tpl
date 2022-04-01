cloudprovidername: "${CLOUDPROVIDER}"
clustername: "${K8SCLUSTER}"
storageclassname: "netapp-anf-perf-standard"
manager_cluster_body: '{
         "defaultStorageClass": "{{ (storageclass_id) }}" ,
         "id": "{{ (cluster_id) }}",
         "type": "application/astra-managedCluster",
         "version": "1.0",
      }'
astra_api_token: ""
astra_account_id: ""
astra_api_endpoint: ""
run_debug: true
