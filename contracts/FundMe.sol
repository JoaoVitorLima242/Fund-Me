// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    address ethUsdPriceFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
    uint256 minimumInUsd = 5e18;
    AggregatorV3Interface priceFeed;

    constructor() {
        priceFeed = AggregatorV3Interface(ethUsdPriceFeedAddress);
    }

    function fund() public payable {
        require(getConversionRate(msg.value) >= minimumInUsd, "didn't send enough ETH");
    }

    function withdraw() public {}

    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;

        return ethAmountInUsd;
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        int256 answerWithTenZeros = answer * 1e10;

        return uint256(answerWithTenZeros);
    }
}
