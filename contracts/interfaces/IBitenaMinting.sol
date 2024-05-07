// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;

interface IBitenaMintingEvents {
    /// @notice Event emitted when contract receives BTC
    event Received(address, uint256);

    /// @notice Event emitted when USDb is minted
    event Mint(
        address minter,
        address benefactor,
        address beneficiary,
        address indexed collateral_asset,
        uint256 indexed collateral_amount,
        uint256 indexed USDb_amount
    );

    /// @notice Event emitted when funds are redeemed
    event Redeem(
        address redeemer,
        address benefactor,
        address beneficiary,
        address indexed collateral_asset,
        uint256 indexed collateral_amount,
        uint256 indexed USDb_amount
    );

    /// @notice Event emitted when custody wallet is added
    event CustodyWalletAdded(address wallet);

    /// @notice Event emitted when a custody wallet is removed
    event CustodyWalletRemoved(address wallet);

    /// @notice Event emitted when a supported asset is added
    event AssetAdded(address indexed asset);

    /// @notice Event emitted when a supported asset is removed
    event AssetRemoved(address indexed asset);

    // @notice Event emitted when a custodian address is added
    event CustodianAddressAdded(address indexed custodian);

    // @notice Event emitted when a custodian address is removed
    event CustodianAddressRemoved(address indexed custodian);

    /// @notice Event emitted when assets are moved to custody provider wallet
    event CustodyTransfer(
        address indexed wallet,
        address indexed asset,
        uint256 amount
    );

    /// @notice Event emitted when USDb is set
    event USDbSet(address indexed USDb);

    /// @notice Event emitted when the max mint per block is changed
    event MaxMintPerBlockChanged(
        uint256 indexed oldMaxMintPerBlock,
        uint256 indexed newMaxMintPerBlock
    );

    /// @notice Event emitted when the max redeem per block is changed
    event MaxRedeemPerBlockChanged(
        uint256 indexed oldMaxRedeemPerBlock,
        uint256 indexed newMaxRedeemPerBlock
    );

    /// @notice Event emitted when a delegated signer is added, enabling it to sign orders on behalf of another address
    event DelegatedSignerAdded(
        address indexed signer,
        address indexed delegator
    );

    /// @notice Event emitted when a delegated signer is removed
    event DelegatedSignerRemoved(
        address indexed signer,
        address indexed delegator
    );
}

interface IBitenaMinting is IBitenaMintingEvents {
    enum Role {
        Minter,
        Redeemer
    }

    enum OrderType {
        MINT,
        REDEEM
    }

    enum SignatureType {
        EIP712
    }

    struct Signature {
        SignatureType signature_type;
        bytes signature_bytes;
    }

    struct Route {
        address[] addresses;
        uint256[] ratios;
    }

    struct Order {
        OrderType order_type;
        uint256 expiry;
        uint256 nonce;
        address benefactor;
        address beneficiary;
        address collateral_asset;
        uint256 collateral_amount;
        uint256 USDb_amount;
    }

    error Duplicate();
    error InvalidAddress();
    error InvalidUSDbAddress();
    error InvalidZeroAddress();
    error InvalidAssetAddress();
    error InvalidCustodianAddress();
    error InvalidOrder();
    error InvalidAffirmedAmount();
    error InvalidAmount();
    error InvalidRoute();
    error UnsupportedAsset();
    error NoAssetsProvided();
    error InvalidSignature();
    error InvalidNonce();
    error SignatureExpired();
    error TransferFailed();
    error MaxMintPerBlockExceeded();
    error MaxRedeemPerBlockExceeded();

    function hashOrder(Order calldata order) external view returns (bytes32);

    function verifyOrder(
        Order calldata order,
        Signature calldata signature
    ) external view returns (bool, bytes32);

    function verifyRoute(
        Route calldata route,
        OrderType order_type
    ) external view returns (bool);

    function verifyNonce(
        address sender,
        uint256 nonce
    ) external view returns (bool, uint256, uint256, uint256);

    function mint(
        Order calldata order,
        Route calldata route,
        Signature calldata signature
    ) external;

    function redeem(
        Order calldata order,
        Signature calldata signature
    ) external;
}
