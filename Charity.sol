// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Charity is Ownable, ReentrancyGuard {
    constructor() Ownable(msg.sender) {}  // <-- FIXED: Use Ownable(msg.sender)

    struct Donation {
        address donor;
        uint256 amount;
        uint256 timestamp;
    }

    Donation[] private _donations;
    uint256 public constant MIN_DONATION = 0.01 ether;
    uint256 public constant MAX_DONATIONS_QUERY_LIMIT = 50;

    event Donated(address indexed donor, uint256 amount, uint256 timestamp);
    event Withdrew(address indexed recipient, uint256 amount);
    event SweptERC20(address indexed token, uint256 amount);

    function donate() external payable {
        require(msg.value >= MIN_DONATION, "Donation too small");
        _donations.push(Donation({
            donor: msg.sender,
            amount: msg.value,
            timestamp: block.timestamp
        }));
        emit Donated(msg.sender, msg.value, block.timestamp);
    }

    function getDonations(uint256 start, uint256 limit) external view returns (Donation[] memory) {
        require(start + limit <= _donations.length, "Invalid range");
        require(limit <= MAX_DONATIONS_QUERY_LIMIT, "Limit too high");
        Donation[] memory batch = new Donation[](limit);
        for (uint256 i = 0; i < limit; i++) {
            batch[i] = _donations[start + i];
        }
        return batch;
    }

    function withdraw(uint256 amount) external nonReentrant onlyOwner {
        require(address(this).balance >= amount, "Insufficient balance");
        payable(owner()).transfer(amount);
        emit Withdrew(owner(), amount);
    }

    function sweepERC20(address tokenAddress, uint256 amount) external onlyOwner {
        IERC20(tokenAddress).transfer(owner(), amount);
        emit SweptERC20(tokenAddress, amount);
    }

    function donationsLength() external view returns (uint256) {
        return _donations.length;
    }

    receive() external payable {
        require(msg.value >= MIN_DONATION, "Donation too small");
    }
}