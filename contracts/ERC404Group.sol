//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC404} from "./ERC404.sol";

contract ERC404Example is Ownable, ERC404 {
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 maxTotalSupplyERC721_
    ) ERC404(name_, symbol_, decimals_) Ownable(msg.sender) {
        // Do not mint the ERC721s to the initial owner, as it's a waste of gas.
        _setERC721TransferExempt(msg.sender, true);
        _mintERC20(msg.sender, maxTotalSupplyERC721_ * units);
    }

    function tokenURI(
        uint256 id_
    ) public pure override returns (string memory) {
        return
            string.concat(
                "ipfs://bafybeidfvzjbovlskk6gw3vtubg4h4adn3k6bms7xwd4ixzl4wh2rfav24/",
                Strings.toString(id_)
            );
    }

    function setERC721TransferExempt(
        address account_,
        bool value_
    ) external onlyOwner {
        _setERC721TransferExempt(account_, value_);
    }
}
