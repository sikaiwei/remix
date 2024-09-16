// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract TestMultiCall {
    function func1() external view returns(uint, uint) {
        return (1, block.timestamp);
    }

    function func2() external view returns(uint, uint) {
        return (2, block.timestamp);
    }

    function getData1() external pure returns(bytes memory) {
        //两种方法
        // return abi.endodeWithSignature("func1()");
        return abi.encodeWithSelector(this.func1.selector);
    }

    function getData2() external pure returns(bytes memory) {
        //两种方法
        // return abi.endodeWithSignature("func2()");
        return abi.encodeWithSelector(this.func2.selector);
    }
}

contract MultiCall {
    function multiCall(address[] calldata targets, bytes[] calldata data) external view returns(bytes[] memory) {
        require(targets.length == data.length, "target length != data length");
        bytes[] memory results = new bytes[](data.length);

        for (uint i; i < targets.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);
            require(success, "tx failed");
            results[i] = result;
        }

        return results;
    }
} 

// 0x0000000000000000000000000000000000000000000000000000000000000001
// 0000000000000000000000000000000000000000000000000000000066e836e6,
// 0x0000000000000000000000000000000000000000000000000000000000000002
// 0000000000000000000000000000000000000000000000000000000066e836e6