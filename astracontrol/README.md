## Config

```yaml
cloudprovidername: "Azure"
clustername: "dynamisch"
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
```

Following Paramter are allowed:

| Parameter | Value |
| --------- | ----- |
| cloudprovidername | Azure, GCP |
| clustername | aks or gke clustername |
| storageclassname | netapp-anf-perf-standard,netapp-cvs-perf-standard,netapp-cvs-perf-extreme,netapp-cvs-perf-premium |
| astra_api_token | your api token |
| astra_account_id | your account id |
| astra_api_endpoint|  e.g astra.netapp.io |
| run_debug | true, false |
