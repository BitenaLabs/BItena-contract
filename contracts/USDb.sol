// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/access/Ownable2Step.sol";

interface IUSDbDefinitions {
    /// @notice This event is fired when the minter changes
    event MinterUpdated(address indexed newMinter, address indexed oldMinter);

    /// @notice Zero address not allowed
    error ZeroAddressException();
    /// @notice It's not possible to renounce the ownership
    error CantRenounceOwnership();
    /// @notice Only the minter role can perform an action
    error OnlyMinter();
}
/**
 * @title USDb
 * @notice Stable Coin Contract
 * @dev Only a single approved minter can mint new tokens
 */
contract USDb is Ownable2Step, ERC20Burnable, ERC20Permit, IUSDbDefinitions {
    address public minter;

    constructor(
        address admin
    ) ERC20("USDb", "USDb") ERC20Permit("USDb") Ownable(admin) {
        if (admin == address(0)) revert ZeroAddressException();
    }

    function setMinter(address newMinter) external onlyOwner {
        emit MinterUpdated(newMinter, minter);
        minter = newMinter;
    }

    function mint(address to, uint256 amount) external {
        if (msg.sender != minter) revert OnlyMinter();
        _mint(to, amount);
    }

    function renounceOwnership() public view override onlyOwner {
        revert CantRenounceOwnership();
    }
}
