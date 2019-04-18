namespace: cs_demo.content.library.demo.aos.test

operation:
  name: uuid

  inputs:
   - input_1
   - input_2

  python_action:
    script: |

  outputs:
   - output_1

  results:
   - SUCCESS: ${returnCode == '0'}
   - FAILURE
