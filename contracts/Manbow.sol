// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC1155Drop.sol";

contract Manbow is ERC1155Drop {
    mapping(uint256 => uint256) public tokenValues;

    event TokensMerged(
        address indexed merger,
        uint256 indexed materialTokenId,
        uint256 indexed productTokenId,
        uint256 productQuantity
    );

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
    {
        tokenValues[0] = 1;
        tokenValues[2] = 20;
        tokenValues[4] = 100;
    }

    function merge(
        address _owner,
        uint256 _materialId,
        uint256 _productId,
        uint256 _productQuantity
    ) external {
        _beforeMerge(_owner, _materialId, _productId, _productQuantity);
        uint256 burnQuantity = _productQuantity * tokenValues[_productId] / tokenValues[_materialId];

        _burn(_owner, _materialId, burnQuantity);
        _mint(_owner, _productId, _productQuantity, "");

        emit TokensMerged(_owner, _materialId, _productId, _productQuantity);
    }

    function _beforeMerge(
        address _owner,
        uint256,
        uint256,
        uint256
    ) internal view virtual {
        if (msg.sender != _owner) {
            revert("Not eligible");
        }
    }
}
