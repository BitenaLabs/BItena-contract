// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

interface IDIAOracleV2 {
    function getValue(string memory) external returns (uint128, uint128);
}

contract IntegrationSampleForTest {
    address immutable ORACLE = 0x9a9a5113b853b394E9BA5FdB7e72bC5797C85191;
    string BTC = "BTC/USD";
    uint128 public latestPrice;
    uint128 public timestampOflatestPrice;

    function getPriceInfo(string memory key) external {
        (latestPrice, timestampOflatestPrice) = IDIAOracleV2(ORACLE).getValue(
            key
        );
    }

    function checkPriceAge(
        uint128 maxTimePassed
    ) external view returns (bool inTime) {
        if ((block.timestamp - timestampOflatestPrice) < maxTimePassed) {
            inTime = true;
        } else {
            inTime = false;
        }
    }
}
