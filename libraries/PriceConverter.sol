// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getConversionRate(uint256 ethAmount)
        internal 
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;

        return ethAmountInUsd;
    }

    function getPrice() internal view returns (uint256) {
        // Sepolia ETH/USD 
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );

        (, int256 answer, , , ) = priceFeed.latestRoundData();
        int256 answerWithTenZeros = answer * 1e10;

        return uint256(answerWithTenZeros);
    }
}
