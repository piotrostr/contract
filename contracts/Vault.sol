// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Vault is ReentrancyGuard, Ownable {
    using SafeMath for uint256;

    constructor() {}

    // TODO pack struct into single memory slot
    struct Payment {
        uint256 amount;
        address sender;
    }

    // bytes32 is just the hash identifier of the payment
    // it is to be supplied from the clientside
    mapping(bytes32 => Payment) public payments;

    mapping(address => uint256) public balances;

    /**
     * @dev simple payment function
     *
     * @param hashIdentifier is just the 32 byte hex id of the payment
     * @param price is supplied through the frontend and { value: price } is
     * also set accordingly
     */
    function deposit(uint256 price, bytes32 hashIdentifier) external payable {
        require(price == msg.value, "price and msg.value mismatch");
        // get the amount of ethers to be paid
        uint256 amount = msg.value;

        // get the sender of the current transaction
        address sender = msg.sender;

        // store the payment in the mapping
        payments[hashIdentifier] = Payment(amount, sender);

        // update the balance of the sender
        balances[sender] += amount;
    }

    function withdraw() external onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{
            value: address(this).balance.mul(8).div(10)
        }("");
        require(success, "withdraw failed");
    }

    receive() external payable {}
}
