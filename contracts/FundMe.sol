// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {PriceConverter} from "libraries/PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 internal minimumInUsd = 5e18;
    address[] public funders;
    mapping(address => uint256) public funds;

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= minimumInUsd,
            "didn't send enough ETH"
        );
        funders.push(msg.sender);
        funds[msg.sender] = funds[msg.sender] + msg.value;
    }

    function withdraw() public {}
}
