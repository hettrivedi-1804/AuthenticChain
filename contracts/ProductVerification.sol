// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract ProductVerification {
    address public owner;

    // serialNumber => productName
    mapping(string => string) private products;
    // Track existence to prevent duplicates and to detect not-found
    mapping(string => bool) private exists;

    event ProductAdded(string indexed serialNumber, string productName);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addProduct(string calldata serialNumber, string calldata productName) external onlyOwner {
        require(bytes(serialNumber).length > 0, "Serial required");
        require(bytes(productName).length > 0, "Name required");
        require(!exists[serialNumber], "Product already exists");

        products[serialNumber] = productName;
        exists[serialNumber] = true;
        emit ProductAdded(serialNumber, productName);
    }

    function getProduct(string calldata serialNumber) external view returns (string memory) {
        if (!exists[serialNumber]) {
            return ""; // empty string indicates not found
        }
        return products[serialNumber];
    }
}
