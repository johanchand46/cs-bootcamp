namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.46
    - username: root
    - password: admin@123
    - filename: accountservice.war
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 79
        y: 157
        navigate:
          79a5f834-82e6-0dc8-5345-7d0102901512:
            targetId: 3f40ce6e-693f-0597-ef01-56b9305dcf5f
            port: SUCCESS
    results:
      SUCCESS:
        ad12d9bf-7008-a77e-d602-7118d0b32054:
          x: 1015
          y: 217
        3f40ce6e-693f-0597-ef01-56b9305dcf5f:
          x: 702
          y: 153
