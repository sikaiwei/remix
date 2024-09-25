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

    uint256 public count;

    function inc() external {
    count += 1;
    }

}


contract CounterV2 {

    uint256 public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }

}


contract Proxy{
    bytes32 public constant IMPLEMENTATION_SLOT = bytes32(uint(keccak256("eip1967.proxy.implementation")) - 1);
    bytes32 public constant ADMIN_SLOT = bytes32(uint(keccak256("eip1967.proxy.admin")) - 1);

    constructor() {
        _setAdmin(msg.sender);
    }

    // function _delegate() private {
    //     (bool ok, bytes memory res) = implementation.delegatecall(msg.data);
    //     require(ok, "delegatecall failed");
    // }

    function _delegate(address _implementation) private {
        assembly {
            // Copy msg.data.We take full control of menory in this inline assembty
            //block becouse it will not retum to Solldity.code.Me ovenrite the
            // Solidity scratch pad at hemory position 0.
            // calldatacopy(t,f,s）-copy s bytcs fron calldata at position f to wem at position 
            //calldatasize()-sizr of coll dota in bytes
            calldatacopy(0, 0, calldatasize())

            //Call the implenentation.
            //out and outslze are B because we don't know the size yet.

            //delegatecVg,a,in,insize,out.ousize）-
            //-coll coract aaddress a
            //-wdth input nem[in（in+insize）)
            //-praviding g gas
            //-and ootout arca Memlout_(out+outsizei)
            //-returningo on crror (eg.out of gas）ond 1 on success
            let result := 
                delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            //returndatacopy(t,f,s)-copy s bytes from returndata at position f to nen at position t
            //returndatasizel)-sizc of the last returndata
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegetecall returns 0 on error.
            case 0 {
                //revert(p,s）-end execution,revert state changes,return data mem[p_（p+s))
                revert(0, returndatasize())
            }
            default {
                //return(p,s)-end execution,return data mem[p-(p+s))
                return (0, returndatasize())
            }

        }
    }


    fallback() external payable {
        _delegate(_getImplementation);
    }

    receive() external payable {
        _delegate(_getImplementation);
    }

    function upgradeTo(address _implementation) external {
        require(msg.sender == _getAdmin(), "not authorized");
        _setImplementation(_implementation);
    }

    function _getAdmin() private view returns(address) {
        return StorageSlot.getAddressSlot(ADMIN_SLOT).value;
    }

    function _setAdmin(address _admin) private {
        require(_admin != address(0), "admin = address 0");
        StorageSlot.getAddressSlot(ADMIN_SLOT).value = _admin;
    }

    function _getImplementation() private view returns(address) {
        return StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value;
    }

    function _setImplementation(address _implementation) private {
        require(_implementation.code.length > 0, "not a contract");
        StorageSlot.getAddressSlot(IMPLEMENTATION_SLOT).value = _implementation;
    }

    function admin() external view returns(address) {
        return _getAdmin();
    }

    function implementation() external view returns(address) {
        return _getImplementation();
    }
}

library StorageSlot {
    struct AddressSlot{
        address value;
    }

    function getAddressSlot(bytes32 slot) internal pure  returns(AddressSlot storage r) {
        assembly {
            r.slot := slot
        }
    }
}

contract TestSlot {
    bytes32 public constant SLOT = keccak256("TEST_SLOT");

    function getSlot() external view returns(address) {
        return StorageSlot.getAddressSlot(SLOT).value;
    }

    function writeSlot(address _addr) external {
        StorageSlot.getAddressSlot(SLOT).value = _addr;
    }
}