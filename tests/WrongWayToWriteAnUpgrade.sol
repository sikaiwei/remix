// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;


// 1．重现透明可升级代理，并探讨其错误实现。
// 2.视频系列内容：
//   －错误实现可升级代理合约，分析错误实现中的问题
//   －返回回退函数中的数据fallback
//   －在智能合约的存储槽中写入任意数据
//   －存储实现合约地址和admin地址
//   －分离admin和user接口
//   --proxy admin合约
//   －实际操作演示

contract CounterV1 {
    address public implementation;
    address public admin;
    uint256 public count;

    function inc() external {
    count += 1;
    }

}


contract CounterV2 {
    address public implementation;
    address public admin;
    uint256 public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }

}


contract BuggyProxy{
    address public implementation;
    address public admin;
    uint256 public count;

    constructor() {
        admin = msg.sender;
    }

    function _delegate() private {
        (bool ok, bytes memory res) = implementation.delegatecall(msg.data);
        require(ok, "delegatecall failed");
    }

    fallback() external payable {
        _delegate();
    }

    receive() external payable {
        _delegate();
    }

    function upgradeTo(address _implementation) external {
        require(msg.sender == admin, "not authorized");
        implementation = _implementation;
    }


}