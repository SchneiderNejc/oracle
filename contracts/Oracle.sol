// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IEthPriceOracle.sol";

contract Oracle is Ownable {
    IEthPriceOracle private iEthPriceOracle;
    
    uint private ethPrice;
    address private oracleAddress;
    mapping(uint=>bool) myRequests;

    event NewOracleAddress(address indexed oracleAddress);
    event ReceivedNewRequestId(uint256 indexed id);
    event PriceUpdated(uint ethPrice, uint indexed id);

    modifier onlyOracle() {
        require(msg.sender == address(iEthPriceOracle), "Not authorized.");
        _;
    }

    function setOracleInstanceAddress(address _oracleInstanceAddress) external onlyOwner {
        oracleAddress = _oracleInstanceAddress;
        iEthPriceOracle = IEthPriceOracle(oracleAddress);
        emit NewOracleAddress(oracleAddress);
    }

    function updateEthPrice() external {
        uint id = iEthPriceOracle.getLatestEthPrice();
        myRequests[id] = true;
        emit ReceivedNewRequestId(id);
    }

    function callback(uint _ethPrice, uint _id) public {
        require(myRequests[_id], "Request not in pending list.");
        ethPrice = _ethPrice;
        delete myRequests[_id];
        emit PriceUpdated(_ethPrice, _id);
    }
}
