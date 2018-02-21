pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";
//import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "./ISmartToken.sol";
import "../Utils.sol";


contract SmartToken is ISmartToken, PausableToken, Utils {

    string public standard = "Token 0.1";
    string public name = "";
    string public symbol = "";
    uint8 public decimals = 0;
    bool public transfersEnabled = false;
    bool public destroyEnabled = false;

    // allows execution only when transfers aren't disabled
    modifier transfersAllowed {
        assert(transfersEnabled);
        _;
    }

    modifier canDestroy() {
        require(destroyEnabled);
        _;
    }

    function SmartToken(string _name, string _symbol, uint8 _decimals) public {
        require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function setDestroyEnabled(bool _enable) public onlyOwner {
        destroyEnabled = _enable;
    }

    function transfer(address _to, uint256 _value) public whenNotPaused transfersAllowed returns (bool) {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused transfersAllowed returns (bool) {
        return super.transferFrom(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
        return super.approve(_spender, _value);
    }

    function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
        return super.increaseApproval(_spender, _addedValue);
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
        return super.decreaseApproval(_spender, _subtractedValue);
    }

    /**
    *
    */
    //@Override
    function disableTransfers(bool _disable) public onlyOwner {
        transfersEnabled = !_disable;
    }

    //@Override
    function issue(address _to, uint256 _amount) public onlyOwner validAddress(_to) notThis(_to) {
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);

        Issuance(_amount);
        Transfer(this, _to, _amount);
    }

    //@Override
    function destroy(address _from, uint256 _amount) public canDestroy {
        require(msg.sender == _from || msg.sender == owner);
        balances[_from] = balances[_from].sub(_amount);
        totalSupply_ = totalSupply_.sub(_amount);
        Destruction(_amount);
        Transfer(_from, 0x0, _amount);
    }
}

