// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import "@erc725/smart-contracts/contracts/interfaces/IERC725Y.sol";

/// @title LuksoUP contract, help Lukso user to get controller address
contract LuksoUP {
    uint256 public constant KEY_ADDRESS =
        0xdf30dba06db6a30e65354d9a64c6098600000000000000000000000000000000;
    bytes32 public constant KEY_COUNT =
        0xdf30dba06db6a30e65354d9a64c609861f089545ca58c6b4dbe31a5f338cb0e3;

    function getData(bytes32 dataKey) external view returns (bytes memory) {}

    function getControllerAddresses(
        IERC725Y user
    ) external view returns (bytes[] memory) {
        bytes memory data = user.getData(KEY_COUNT);

        uint8 number = uint8(data[data.length - 1]);

        bytes32[] memory keys = new bytes32[](number);
        for (uint8 i = 0; i < keys.length; i++) {
            keys[i] = bytes32(KEY_ADDRESS + i);
        }

        return user.getDataBatch(keys);
    }
}
