// SPDX-License-Identifier: MIT

pragma solidity ^0.8;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Xolotl is ERC20("Xolotl", "xLT") {
    using SafeMath for uint256;
    IERC20 public axo;

    // Define the Axo token contract
    constructor(IERC20 _axo) {
        axo = _axo;
    }

    // Locks Axo and mints xAxo
    function enter(uint256 _amount) public {
        // Gets the amount of Axo locked in the contract
        uint256 totalAxo = axo.balanceOf(address(this));
        // Gets the amount of xAxo in existence
        uint256 totalShares = totalSupply();
        // If no xAxo exists, mint it 1:1 to the amount put in
        if (totalShares == 0 || totalAxo == 0) {
            _mint(msg.sender, _amount);
        } 
        // Calculate and mint the amount of xAxo the Axo is worth. The ratio will change overtime, as xAxo is burned/minted and Axo deposited + gained from fees / withdrawn.
        else {
            uint256 what = _amount.mul(totalShares).div(totalAxo);
            _mint(msg.sender, what);
        }
        // Lock the Axo in the contract
        axo.transferFrom(msg.sender, address(this), _amount);
    }

    // Unlocks the staked + gained Axo and burns xAxo
    function leave(uint256 _share) public {
        // Gets the amount of xAxo in existence
        uint256 totalShares = totalSupply();
        // Calculates the amount of Axo the xAxo is worth
        uint256 what = _share.mul(axo.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        axo.transfer(msg.sender, what);
    }

    // returns the total amount of AXO an address has in the contract including fees earned
    function AXOBalance(address _account) external view returns (uint256 axoAmount_) {
        uint256 xLTAmount = balanceOf(_account);
        uint256 totalxLT = totalSupply();
        axoAmount_ = xLTAmount.mul(axo.balanceOf(address(this))).div(totalxLT);
    }

    // returns how much AXO someone gets for redeeming XLT
    function xLTForAXO(uint256 _xLTAmount) external view returns (uint256 axoAmount_) {
        uint256 totalxLT = totalSupply();
        axoAmount_ = _xLTAmount.mul(axo.balanceOf(address(this))).div(totalxLT);
    }

    // returns how much XLT someone gets for depositing AXO
    function AXOForxLT(uint256 _axoAmount) external view returns (uint256 xLTAmount_) {
        uint256 totalAxo = axo.balanceOf(address(this));
        uint256 totalxLT = totalSupply();
        if (totalxLT == 0 || totalAxo == 0) {
            xLTAmount_ = _axoAmount;
        }
        else {
            xLTAmount_ = _axoAmount.mul(totalxLT).div(totalAxo);
        }
    }
}