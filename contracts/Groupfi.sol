// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

/// @title Groupfi contract, help groupfi to supply some data servies
contract Groupfi {
    // uint16 public constant PERCENT = 10000;

    /// the wallet address to recieve eth token
    address public immutable wallet;

    /// event log to listen
    event BuySmr(
        address indexed user,
        bytes32 indexed pubkey,
        uint256 amountIn,
        uint64 amountOut
    );

    /// @param w The wallet address to recieve eth
    constructor(address w) {
        wallet = w;
    }

    /// @notice transfer eth to buy some smr
    /// @param amount the amount of smr
    /// @param ed25519 the ed25519 address
    function buySmr(bytes32 ed25519, uint64 amount) external payable {
        require(amount >= 1000000, "amount>=1");
        safeTransferETH(wallet, msg.value);
        emit BuySmr(msg.sender, ed25519, msg.value, amount);
    }

    /// @notice filterEthAddresses
    /// @param addrs addresses to filter
    /// @param threshold the threshold value of eth balance
    /// @dev Returns the addresses indexes that do not belong to a group, and the total count.
    function filterEthAddresses(
        address[] memory addrs,
        uint256 threshold
    ) external view returns (uint16[] memory indexes, uint16 count) {
        indexes = new uint16[](addrs.length);
        for (uint16 i = 0; i < addrs.length; i++) {
            if (addrs[i].balance < threshold) {
                indexes[count] = i;
                count++;
            }
        }
    }

    /// @notice filterERC20Addresses
    /// @param addrs addresses to filter
    /// @param c ERC20 contract address
    /// @param threshold the threshold value of erc20's balance
    /// @dev Returns the addresses indexes that do not belong to a group, and the total count.
    function filterERC20Addresses(
        address[] memory addrs,
        IERC20 c,
        uint256 threshold
    ) external view returns (uint16[] memory indexes, uint16 count) {
        // threshold = (c.totalSupply() * threshold) / PERCENT;
        indexes = new uint16[](addrs.length);
        for (uint16 i = 0; i < addrs.length; i++) {
            if (c.balanceOf(addrs[i]) < threshold) {
                indexes[count] = i;
                count++;
            }
        }
    }

    /// @notice filterERC20Addresses
    /// @param addrs addresses to filter
    /// @param c ERC721 contract address
    /// @dev Returns the addresses indexes that do not belong to a group, and the total count.
    function filterERC721Addresses(
        address[] memory addrs,
        IERC721 c
    ) external view returns (uint16[] memory indexes, uint16 count) {
        indexes = new uint16[](addrs.length);
        for (uint16 i = 0; i < addrs.length; i++) {
            if (c.balanceOf(addrs[i]) == 0) {
                indexes[count] = i;
                count++;
            }
        }
    }

    /// @notice filterERC20Addresses
    /// @param addrs addresses to filter
    /// @param c ERC721 contract address
    /// @param id the id of user's token
    /// @dev Returns the addresses indexes that do not belong to a group, and the total count.
    function filterERC1155Addresses(
        address[] memory addrs,
        IERC1155 c,
        uint256 id,
        uint256 threshold
    ) external view returns (uint16[] memory indexes, uint16 count) {
        indexes = new uint16[](addrs.length);
        for (uint16 i = 0; i < addrs.length; i++) {
            if (c.balanceOf(addrs[i], id) < threshold) {
                indexes[count] = i;
                count++;
            }
        }
    }

    /// @notice checkEthGroup
    /// @param adds addresses that be added to the group
    /// @param subs addresses that be removed from the group
    /// @param threshold the threshold value of eth balance
    /// @dev Returns the check result. 0 is true, 1 is adds error and -1 is subs error.
    function checkEthGroup(
        address[] memory adds,
        address[] memory subs,
        uint256 threshold
    ) external view returns (int8 res) {
        for (uint256 i = 0; i < adds.length; i++) {
            if (adds[i].balance < threshold) {
                return 1;
            }
        }

        for (uint256 i = 0; i < subs.length; i++) {
            if (subs[i].balance >= threshold) {
                return -1;
            }
        }
        return 0;
    }

    /// @notice filterERC20Addresses
    /// @param adds addresses that be added to the group
    /// @param subs addresses that be removed from the group
    /// @param c ERC20 contract address
    /// @param threshold the threshold value of erc20's balance
    /// @dev Returns the check result. 0 is true, 1 is adds error and -1 is subs error.
    function checkERC20Group(
        address[] memory adds,
        address[] memory subs,
        IERC20 c,
        uint256 threshold
    ) external view returns (int8 res) {
        for (uint256 i = 0; i < adds.length; i++) {
            uint256 a = c.balanceOf(adds[i]);
            if (a < threshold) {
                return 1;
            }
        }

        for (uint256 i = 0; i < subs.length; i++) {
            uint256 a = c.balanceOf(subs[i]);
            if (a >= threshold) {
                return -1;
            }
        }
        return 0;
    }

    /// @notice filterERC721Addresses
    /// @param adds addresses that be added to the group
    /// @param subs addresses that be removed from the group
    /// @param c ERC721 contract address
    /// @dev Returns the check result. 0 is true, 1 is adds error and -1 is subs error.
    function checkERC721Group(
        address[] memory adds,
        address[] memory subs,
        IERC721 c
    ) external view returns (int8) {
        for (uint256 i = 0; i < adds.length; i++) {
            if (c.balanceOf(adds[i]) == 0) {
                return 1;
            }
        }
        for (uint256 i = 0; i < subs.length; i++) {
            if (c.balanceOf(adds[i]) > 0) {
                return -1;
            }
        }
        return 0;
    }

    /// @notice filterERC20Addresses
    /// @param adds addresses that be added to the group
    /// @param subs addresses that be removed from the group
    /// @param c ERC20 contract address
    /// @param id the id of user's token
    /// @param threshold the threshold value of erc20's balance
    /// @dev Returns the check result. 0 is true, 1 is adds error and -1 is subs error.
    function checkERC1155Group(
        address[] memory adds,
        address[] memory subs,
        IERC1155 c,
        uint256 id,
        uint256 threshold
    ) external view returns (int8 res) {
        for (uint256 i = 0; i < adds.length; i++) {
            uint256 a = c.balanceOf(adds[i], id);
            if (a < threshold) {
                return 1;
            }
        }

        for (uint256 i = 0; i < subs.length; i++) {
            uint256 a = c.balanceOf(subs[i], id);
            if (a >= threshold) {
                return -1;
            }
        }
        return 0;
    }

    /// @notice Transfers ETH to the recipient address
    /// @dev Fails with `STE`
    /// @param to The destination of the transfer
    /// @param value The value to be transferred
    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, "STE");
    }
}
