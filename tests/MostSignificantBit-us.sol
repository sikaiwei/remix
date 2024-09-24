// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract MostSignificantBit{
    // 10101010 -> 7
    function findMostSignificantBit(uint256 x) external pure returns(uint8 r){
        // x >= 2 ** 128
        if ( x >= 2 ** 128){
            x >>=128;
            r += 128;
        }
        // x >= 2 ** 64
        if (x >= 2 ** 64){
            x >>= 64;
            r += 64;
        }
        // x >= 2 ** 32
        if (x >= 2 ** 32){
            x >>= 32;
            r += 32;
        }
        // x >= 2 ** 16
        if (x >= 2 ** 16){
            x >>= 16;
            r += 16;
        }
        // x >= 2 ** 8
        if (x>=2 ** 8){
            x >>= 8;
            r +=8;
        }
        //x>=2**4
        if (x >= 2 ** 4){
            x >>= 4;
            r += 4;
        }
        // x >= 2 ** 2
        if (x >= 2 ** 2){
            x >>= 2;
            r +=  2;
        }
        // x >=2 ** 1
        if (x >= 2 ** 1){
            r +=  1;
        }
    }

    // MSB 函数： 使用汇编语言优化
    function mostSignificantBit(uint256 x) public pure returns(uint256 r) {
        // 两种写法：
        // assembly {
        //     // 比较和位移操作的汇编实现
        //     if gt(x, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) {
        //         x := shr(128, x)
        //         r := add(r, 128)
        //     }
        // }

        assembly {
            let f := shl(7, gt(x, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
            x := shr(f, x)
            // or can be replaced with add
            r := or(r, f)
        }

        assembly {
            let f := shl(6, gt(x, 0xFFFFFFFFFFFFFFFF))
            x := shr(f, x)
            r := or(r, f)
        }


        assembly {
            let f := shl(5, gt(x, 0xFFFFFFFF))
            x := shr(f, x)
            r := or(r, f)
        }

        assembly {
            let f := shl(4, gt(x, 0xFFFF))
            x := shr(f, x)
            r := or(r, f)
        }

        assembly {
            let f := shl(3, gt(x, 0xFF))
            x := shr(f, x)
            r := or(r, f)
        }


        assembly {
            let f := shl(2, gt(x, 0xF))
            x := shr(f, x)
            r := or(r, f)
        }

        assembly {
            let f := shl(1, gt(x, 0x3))
            x := shr(f, x)
            r := or(r, f)
        }

        assembly {
            let f := gt(x, 0x1)
            r := or(r, f)
        }

    }

}