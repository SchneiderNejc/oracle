// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IOracle.sol";

contract EthPriceOracle is Ownable {
    IOracle iOracle;

    uint private randNonce = 0;
    uint private modulus = 1000;
    mapping (uint => bool) pendingRequests;

    event GetLatestEthPrice(address callerAddress, uint id);
    event SetLatestEthPrice(uint ethPrice, address caller);

    function getLatestEthPrice () external returns(uint) {
        /// @dev Deterministic and unsafe. 
        uint id = uint(keccak256(abi
            .encodePacked(block.timestamp, msg.sender, randNonce))) % modulus;
        randNonce++;

        pendingRequests[id] = true;

        emit GetLatestEthPrice(msg.sender, id);

        return id;
    }

    function setLatestEthPrice(uint _ethPrice, address _callerAddress, uint _id) external onlyOwner {
        require(pendingRequests[_id], "Request not on pending list");
        delete pendingRequests[_id];

        iOracle = IOracle(_callerAddress);
        iOracle.callback(_ethPrice, _id);

        emit SetLatestEthPrice(_ethPrice, _callerAddress);
    }
}