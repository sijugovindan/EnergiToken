// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import './IupgERC20.sol';
import './Initializable.sol';

contract upgERC20 is Initializable{
    string private symbol;
    string private name;
    uint8 private decimals;
    uint256 private totalSupply;
    mapping (address=>uint256) private balances;
    mapping (address=>mapping (address=>uint256)) private allowed;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function __ERC20_init(string memory _name, string memory _symbol, uint8 _decimals) 
    internal 
    initializer
    {
        symbol = _symbol;
        name = _name;
        decimals = _decimals;
    }
    
    function balanceOf(address _owner) 
    view public 
    returns (uint256 balance) 
    {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _amount) 
    public returns (bool success) 
    {
        require (balances[msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
        balances[msg.sender]-=_amount;
        balances[_to]+=_amount;
        emit Transfer(msg.sender,_to,_amount);
        return true;
    }
  
    function transferFrom(address _from,address _to,uint256 _amount) 
    public returns (bool success) 
    {
        require (balances[_from]>=_amount&&allowed[_from][msg.sender]>=_amount&&_amount>0&&balances[_to]+_amount>balances[_to]);
        balances[_from]-=_amount;
        allowed[_from][msg.sender]-=_amount;
        balances[_to]+=_amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }
  
    function approve(address _spender, uint256 _amount) 
    public returns (bool success) 
    {
        allowed[msg.sender][_spender]=_amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }
    
    function allowance(address _owner, address _spender) 
    view public returns (uint256 remaining) 
    {
      return allowed[_owner][_spender];
    }
    
    function _mint(address account, uint256 amount) 
    internal virtual 
    {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        totalSupply += amount;
        balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }
    
    
     function _burn(address account, uint256 amount) 
     internal virtual 
     {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        balances[account] = accountBalance - amount;
        totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) 
    internal virtual { }
}