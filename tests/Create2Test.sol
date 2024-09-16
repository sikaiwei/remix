// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

contract DeployWithCreate2 {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }
}

contract Create2Factory {
    event Deploy (address addr);

    function deploy(uint _salt) external {
        DeployWithCreate2 _contract = new DeployWithCreate2{
            salt: bytes32(_salt)
        }(msg.sender);
        emit Deploy(address(_contract));
    }

    function getAddress(bytes memory bytecode, uint _salt) public view  returns(address) {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),address(this), _salt, keccak256(bytecode)
            )
        );
        // 20/32 = 0.625
        // 160/256 = 0.625
        return address(uint160(uint256(hash)));
    }

    function getBytecode(address _owner) public pure returns(bytes memory) {
        bytes memory bytecode = type(DeployWithCreate2).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_owner));
    }
}