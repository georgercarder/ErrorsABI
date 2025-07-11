# ErrorsABI

## Consolidate solidity custom errors abi of a project for more sane UI error handling

### usage

In root of a forge project, run

`./update_errors_abi.sh` <DESIRED_TARGET_FILEPATH>

Resulting file will look like:

```
"use strict";

export const ErrorsABI = [
 { 
    "type": "error",
    "name": "NotOwner_error",
    "inputs": []
  },

  // ... etc
];
```

.. then in error handling where there may be a contract revert

```
// ...

import {ErrorsABI} from <DESIRED_TARGET_FILEPATH>;

    try {
        // ...
    } catch (err) {
        if (err.data) {
            const errs = new ethers.Contract(ethers.ZeroAddress, ErrorsABI, /*signer*/ ) 
            const decodedError = errs.interface.parseError(err.data);

            // use this ^^

        }
    }
```


Please make git issues if you find breakage or areas for improvement.


not audited. use at your own risk.

Support my work on this module by donating ETH or other coins to

`0x1331DA733F329F7918e38Bc13148832D146e5adE`
