namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.46
    - username: root
    - password: admin@123
    - artifact_url:
        default: 'http://vmdocker.hcm.demo.local:36980/job/AOS/lastSuccessfulBuild/artifact/accountservice/target/accountservice.war'
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${artifact_url}'
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - url: '${script_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: ssh_command
    - ssh_command:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_co: '${command_return_code}'
        navigate:
          - SUCCESS: delete_file
          - FAILURE: delete_file
    - delete_file:
        do:
          Integrations.demo.aos.tools.delete_file:
            - host: '${host}'
            - username: '${username}'
            - password: '${password}'
            - filename: '${script_name}'
        navigate:
          - SUCCESS: is_artifact_given_1
          - FAILURE: on_failure
    - is_artifact_given_1:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${command_return_co}'
            - second_string: '0'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 430
        y: 22
      copy_artifact:
        x: 241
        y: 98
      copy_script:
        x: 516
        y: 162
      ssh_command:
        x: 235
        y: 341
      delete_file:
        x: 500
        y: 342
      is_artifact_given_1:
        x: 593
        y: 500
        navigate:
          2f74bbf4-e37d-6872-f849-b314046e9b1f:
            targetId: 9a354981-5235-8147-706c-d3be74ac6e25
            port: SUCCESS
    results:
      SUCCESS:
        9a354981-5235-8147-706c-d3be74ac6e25:
          x: 700
          y: 416
