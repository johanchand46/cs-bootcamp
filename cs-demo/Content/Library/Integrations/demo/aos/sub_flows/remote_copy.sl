namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host: 10.0.46.46
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS/lastSuccessfulBuild/artifact/accountservice/target/accountservice.war'
  workflow:
    - extract_filename:
        do:
          io.cloudslang.demo.aos.tools.extract_filename:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        navigate:
          - SUCCESS: remote_secure_copy_1
          - FAILURE: on_failure
    - remote_secure_copy_1:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: "${get_sp('script_location')}"
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - filename: '${filename}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename:
        x: 105
        y: 69
      get_file:
        x: 371
        y: 119
      remote_secure_copy_1:
        x: 403
        y: 304
        navigate:
          e343b5b1-24b5-4fd0-0f81-41d373eab738:
            targetId: e0edfcda-d034-9f80-b872-ff7776a1c23d
            port: SUCCESS
    results:
      SUCCESS:
        e0edfcda-d034-9f80-b872-ff7776a1c23d:
          x: 666
          y: 132
