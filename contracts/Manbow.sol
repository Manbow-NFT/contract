// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC1155Drop.sol";

contract Manbow is ERC1155Drop {
    mapping(uint256 => mapping(uint256 => uint256)) public tokenRate;

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
        tokenRate[0][2] = 20;
        tokenRate[0][4] = 100;
        tokenRate[2][4] = 5;
    }

    function claim(
        address _receiver,
        uint256 _tokenId,
        uint256 _quantity,
        address _currency,
        uint256 _pricePerToken,
        AllowlistProof calldata _allowlistProof,
        bytes memory _data
    ) public payable virtual override {
        _beforeClaim(_tokenId, _receiver, _quantity, _currency, _pricePerToken, _allowlistProof, _data);

        ClaimCondition memory condition = claimCondition[_tokenId];
        bytes32 activeConditionId = conditionId[_tokenId];

        verifyClaim(_tokenId, _dropMsgSender(), _quantity, _currency, _pricePerToken, _allowlistProof);

        // Update contract state.
        condition.supplyClaimed += _quantity;
        supplyClaimedByWallet[activeConditionId][_dropMsgSender()] += _quantity;
        claimCondition[_tokenId] = condition;

        // If there's a price, collect price.
        _collectPriceOnClaim(address(0), _quantity, _currency, _pricePerToken);

        // Mint the relevant NFTs to claimer.
        _transferTokensOnClaim(_receiver, _tokenId, _quantity);

        emit TokensClaimed(_dropMsgSender(), _receiver, _tokenId, _quantity);

        _afterClaim(_tokenId, _receiver, _quantity, _currency, _pricePerToken, _allowlistProof, _data);
    }
}
