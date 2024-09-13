// SPDX-License-Identifier: Apache-2.0
pragma solidity >0.8.0;

import "@lukso/lsp7-contracts/contracts/LSP7DigitalAsset.sol";

contract MyLSP7Token is LSP7DigitalAsset {
    constructor(
        string memory name, // Name of the token
        string memory symbol, // Symbol of the token
        uint256 lsp4tokenType, // 0 if representing a fungible token, 1 if representing an NFT
        bool isNonDivisible // false for decimals equal to 18, true for decimals equal to 0
    )
        LSP7DigitalAsset(
            name,
            symbol,
            msg.sender,
            lsp4tokenType,
            isNonDivisible
        )
    {}

    function mint(address to, uint256 amount) external onlyOwner {
        // _mint(to, amount, force, data)
        // force: should be set to true to allow EOA to receive tokens
        // data: only relevant if the `to` is a smart contract supporting LSP1.
        _mint(to, amount, true, "");
    }
}
