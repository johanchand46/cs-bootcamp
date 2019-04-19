namespace: Integrations.demo.vmware
flow:
  name: deploy_vm
  inputs:
    - host: "${get_sp('vcenter_host')}"
    - user: "${get_sp('vcenter_user')}"
    - password: "${get_sp('vcenter_password')}"
    - image: "${get_sp('vcenter_image')}"
    - datacenter: "${get_sp('vcenter_datacenter')}"
    - folder: "${get_sp('vcenter_folder')}"
    - prefix: jc-
  workflow:
    - unique_vm_name_generator:
        do:
          io.cloudslang.vmware.vcenter.util.unique_vm_name_generator:
            - vm_name_prefix: '${prefix}'
        publish:
          - vm_name
        navigate:
          - SUCCESS: clone_vm
          - FAILURE: on_failure
    - clone_vm:
        do:
          io.cloudslang.vmware.vcenter.vm.clone_vm:
            - host: '${host}'
            - user: '${user}'
            - password:
                value: '${password}'
                sensitive: true
            - port: '443'
            - protocol: https
            - close_session: 'true'
            - async: 'false'
            - vm_source_identifier: name
            - vm_source: '${image}'
            - datacenter: '${datacenter}'
            - vm_name: '${vm_name}'
            - vm_folder: '${folder}'
            - mark_as_template: 'false'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        publish:
          - vm_id
        navigate:
          - SUCCESS: power_on_vm
          - FAILURE: on_failure
    - power_on_vm:
        do:
          io.cloudslang.vmware.vcenter.power_on_vm:
            - host: '${host}'
            - user: '${user}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_identifier: name
            - vm_name: '${vm_name}'
            - datacenter: '${datacenter}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        navigate:
          - SUCCESS: wait_for_vm_info
          - FAILURE: on_failure
    - wait_for_vm_info:
        do:
          io.cloudslang.vmware.vcenter.util.wait_for_vm_info:
            - host: '${host}'
            - user: '${user}'
            - password:
                value: '${password}'
                sensitive: true
            - vm_identifier: name
            - vm_name: '${vm_name}'
            - datacenter: '${datacenter}'
            - trust_all_roots: 'true'
            - x_509_hostname_verifier: allow_all
        publish:
          - ip
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - ip: '${ip}'
    - vm_name: '${vm_name}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      unique_vm_name_generator:
        x: 82
        y: 155
      clone_vm:
        x: 310
        y: 205
      power_on_vm:
        x: 103
        y: 306
      wait_for_vm_info:
        x: 284
        y: 358
        navigate:
          6363aaa4-6490-52c5-ab3b-ad5dc513dfe9:
            targetId: 3a8781f2-6c11-883f-14ce-7c38394b932a
            port: SUCCESS
    results:
      SUCCESS:
        3a8781f2-6c11-883f-14ce-7c38394b932a:
          x: 618
          y: 154
