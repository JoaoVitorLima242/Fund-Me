// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PriceConverter} from "libraries/PriceConverter.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 internal constant MINIMUM_USD = 5e18;
    address[] public funders;
    mapping(address => uint256) public funds;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIMUM_USD,
            "didn't send enough ETH"
        );
        funders.push(msg.sender);
        funds[msg.sender] += msg.value;
    }

    function withdraw() public isOwner {
        for (uint256 i; i < funders.length; i = i++) {
            address funder = funders[i];
            funds[funder] = 0;
        }
        funders = new address[](0);

        // transfer - If fails it will throw an error
        // payable(msg.sender).transfer(address(this).balance);

        // send - It will returns an bool
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");

        // call
        (bool callSucces, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSucces, "Call failed");
    }

    modifier isOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
