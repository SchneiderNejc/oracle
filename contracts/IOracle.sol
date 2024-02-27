// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;
interface IOracle {
  function callback(uint256 _ethPrice, uint256 id) external;
}
