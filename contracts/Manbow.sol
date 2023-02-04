// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC1155Drop.sol";

contract Manbow is ERC1155Drop {
    constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps,
        address _primarySaleRecipient
    )
        ERC1155Drop(
            _name,
            _symbol,
            _royaltyRecipient,
            _royaltyBps,
            _primarySaleRecipient
        )
    {}

    function reproduce(
        address _to,
        uint256 _amount,
        bytes memory _data
    ) external onlyOwner {
        _mint(_to, 0, _amount, _data);
    }

    function burn(address _to, uint256 _amount) external onlyOwner {
        _burn(_to, 0, _amount);
    }
}