namespace: Integrations.demo.aos.test
flow:
  name: deploy_wars_test
  inputs:
    - tomcat_host:
        default: 10.0.46.46
        required: false
    - account_service_host: 10.0.46.46
    - db_host:
        default: 10.0.46.46
        required: false
    - username: "${get_sp('vm_username')}"
    - password: "${get_sp('vm_password')}"
    - url: "${get_sp('war_repo_root_url')}"
  workflow:
    - deploy_account_service:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: '${username}'
            - password: '${password}'
            - artifact_url: "${url+'accountservice/target/accountservice.war'}"
            - script_url: "${get_sp('script_deploy_war')}"
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_account_service:
        x: 45
        y: 109
        navigate:
          cd9bafe3-2257-07cd-6f81-91a0ea7e3372:
            targetId: 50cd353b-7116-d24d-85b2-c791c802336c
            port: SUCCESS
    results:
      SUCCESS:
        50cd353b-7116-d24d-85b2-c791c802336c:
          x: 640
          y: 110
