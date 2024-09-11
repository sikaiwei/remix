// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract EtherWallet {
    address payable  public owner;
    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable { }

    function withDraw(uint _amount) external {
        require(owner == msg.sender, "Caller is not owner");
        owner.transfer(_amount);
    }

    function showBlance() external view returns(uint) {
        // return msg.sender.balance;
        return address(this).balance;
    }
}