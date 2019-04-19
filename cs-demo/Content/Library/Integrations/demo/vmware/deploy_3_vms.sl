namespace: Integrations.demo.vmware
flow:
  name: deploy_3_vms
  workflow:
    - deploy_vm:
        parallel_loop:
          for: "prefix in 'jc-tm-','jc-as-','jc-db-'"
          do:
            Integrations.demo.vmware.deploy_vm:
              - prefix: '${prefix}'
        publish:
          - ip_li: '${str([str(x["ip"]) for x in branches_context])}'
          - vm_name_li: '${str([str(x["vm_name"]) for x in branches_context])}'
          - tomcat_host: '${str(branches_context[0]["ip"])}'
          - account_service_host: '${str(branches_context[1]["ip"])}'
          - db_host: '${str(branches_context[2]["ip"])}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_vm:
        x: 109
        y: 109
        navigate:
          8a4a4aae-3627-9fdf-5e05-a47387895a78:
            targetId: 532d5419-e057-a990-b35f-56dc9d9db3e1
            port: SUCCESS
    results:
      SUCCESS:
        532d5419-e057-a990-b35f-56dc9d9db3e1:
          x: 450
          y: 117
