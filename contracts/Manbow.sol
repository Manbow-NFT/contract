// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC1155Drop.sol";

contract Manbow is ERC1155Drop {
    mapping(uint256 => mapping(uint256 => uint256)) public tokenRates;

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
        tokenRates[0][2] = 20;
        tokenRates[0][4] = 100;
        tokenRates[2][4] = 5;
    }

    function _dropMsgSender() internal view override returns (address) {
        return msg.sender;
    }

    function merge(
        address _owner,
        uint256 _materialId,
        uint256 _productId,
        uint256 _productQuantity
    ) external payable {
        uint256 burnQuantity = _productQuantity * tokenRates[_materialId][_productId];
        _beforeMerge(_owner, _materialId, _productId, burnQuantity);

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
        if (_dropMsgSender() != _owner) {
            revert("Not eligible");
        }
    }
}
