// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract B {
    // storage layout must be the same as contract A 
    uint256 public num;
    address public sender;
    uint256 public value;
    string public ddd;


    function setVars(uint256 _num) public payable {
        num = 2 * _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A {
    uint256 public num;
    address public sender;
    uint256 public value;
    string public ffff;


    function setVars(address _contract, uint256 _num) public payable {
        // A's storage is set, B is not modified
        // _contract.delegatecall(
        //     abi.encodeWithSignature("setVars(uint256)", _num)
        // );
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSelector(B.setVars.selector, _num)
        );
        require(success, "delegatecall failed");
    }
}