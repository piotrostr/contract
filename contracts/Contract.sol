// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Contract is ReentrancyGuard, Ownable {
    constructor() {}

    receive() external payable {}

    function withdraw() external onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{ value: address(this).balance.mul(8).div(10) }("");
        require(success, "withdraw failed");
    }
}
