// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    address ethUsdPriceFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    uint256 minimumInUsd = 5;
    AggregatorV3Interface priceFeed;

    constructor() {
        priceFeed = AggregatorV3Interface(ethUsdPriceFeedAddress);
    }

    function fund() public {}

    function withdraw() public {}

    function getPrice() public view returns(uint256) {
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer *1e10);
    }
}
