namespace: Integrations.demo.aos
flow:
  name: install_aos
  inputs:
    - username: "${get_sp('vm_username')}"
    - password: "${get_sp('vm_password')}"
    - tomcat_host: 10.0.46.46
    - account_service_host:
        required: false
    - db_host: 10.0.46.46
  workflow:
    - install_postgres:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: "${get('db_host', tomcat_host)}"
            - script_url: "${get_sp('script_install_postgres')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_java
    - install_java:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - script_url: "${get_sp('script_install_java')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat
    - install_tomcat:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${tomcat_host}'
            - script_url: "${get_sp('script_install_tomcat')}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_true
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(get('account_service_host', tomcat_host) != tomcat_host)}"
        navigate:
          - 'TRUE': install_java_as
          - 'FALSE': SUCCESS
    - install_java_as:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: install_tomcat_as
    - install_tomcat_as:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      install_postgres:
        x: 121
        y: 103
      install_java:
        x: 294
        y: 103
      install_tomcat:
        x: 522
        y: 94
      is_true:
        x: 343
        y: 298
        navigate:
          666048d6-2bd6-ec23-8e5b-eb7748c08f56:
            targetId: c9e58448-f008-5336-6f22-eb3761a99fb9
            port: 'FALSE'
      install_java_as:
        x: 139
        y: 438
      install_tomcat_as:
        x: 301
        y: 442
        navigate:
          8326a5c4-48bf-843b-26c1-2f421e38ebbb:
            targetId: c9e58448-f008-5336-6f22-eb3761a99fb9
            port: SUCCESS
    results:
      SUCCESS:
        c9e58448-f008-5336-6f22-eb3761a99fb9:
          x: 531
          y: 311
