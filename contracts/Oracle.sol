// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract Oracle {
    address private oracleAddress;
    function setOracleInstanceAddress(address _oracleInstanceAddress) public {
        oracleAddress = _oracleInstanceAddress;
    }
}
