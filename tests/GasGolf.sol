// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract GasGolf {
    // start  55167 gas
    // use calldata  54438 gas
    // load state variables to memory  54187 gas
    // short circuit  - 53815 gas
    // loop increments - 53304 gas
    // cache array length - deprecated
    // load array elements to memory - 53097 gas

    uint256 public total;

    // [1,2,3,4,5,100]
    function sumIfEvenAndLessThan99(uint[] memory nums) external {
        uint _total = total;
        for (uint i = 0; i < nums.length; ++i) {
            uint num = nums[i];
            if (num % 2 == 0 && num < 99) {
                _total += num;
            }
        }
        total = _total;
    }
}