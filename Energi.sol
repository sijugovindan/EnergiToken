// SPDX-License-Identifier: none

pragma solidity ^0.8.4;

import './upgERC20.sol';

contract EnergiToken is Initializable, upgERC20 {

    address private owner;
    function initialize(
        address _owner,
        string calldata _name,
        string calldata _symbol,
        uint8 _decimals
    ) external initializer
    {
        __ERC20_init(_name, _symbol, _decimals);
        require(_owner != address(0));
        owner = _owner;
    }
    
    modifier onlyOwner() {
        require(owner == msg.sender, "caller is not the owner");
        _;
    }

    function changeOwner(address _owner) external onlyOwner{
        owner = _owner;
    }

    function mint(address recipient, uint amount) external onlyOwner{
        _mint(recipient, amount);
    }

    function burn(address recipient, uint amount) external onlyOwner{
        _burn(recipient, amount);
    }
 

}