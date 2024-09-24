// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract UncheckedMath {
    function add(uint256 x, uint256 y) external pure returns (uint256) { 
        //927
        return x + y;

        // 748
        // unchecked {
        //     return x + y;
        // }
    }



    function sub(uint256 x, uint256 y) external pure returns (uint256) { 
        //971
        return x - y;

        // 792
        // unchecked {
        //     return x - y;
        // }
    }


    function sumOfCubes(uint256 x, uint256 y) external pure returns (uint256) {

        // 827
        unchecked {
            uint256 x3 = x * x * x;
            uint256 y3 = y * y * y;
            return x3 + y3;
        }
    }
}

