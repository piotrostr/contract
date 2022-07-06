// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Vault is ReentrancyGuard, Ownable {
    using SafeMath for uint256;

    // TODO pack struct into single memory slot
    // TODO solidity needs to have hovers on built-in keywords
    struct Payment {
        uint256 amount;
        address sender;
    }

    // bytes32 is just the hash identifier of the payment
    // it is to be supplied from the clientside
    mapping(bytes32 => Payment) public payments;

    // balances of users (might be useful to use for withdrawals in the future)
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

    /**
     * @dev the function lets you get 0.1 ethereum
     */
    function getSomeEther() external nonReentrant {
        // check if there is enough ether
        bool balanceSufficient = address(this).balance >= 0.1 ether;
        require(balanceSufficient, "no ether left");

        // withdraw to address calling the function
        (bool success, ) = msg.sender.call{ value: 0.1 ether }("");
        require(success, "withdraw failed");
    }

    receive() external payable {}
}
