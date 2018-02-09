pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "./Distributable.sol";

contract DistributionToken is StandardToken, Distributable {
  event Mint(address indexed dealer, address indexed to, uint256 value);
  event Burn(address indexed dealer, address indexed from, uint256 value);

   /**
   * @dev to mint tokens
   * @param _to The address that will recieve the minted tokens.
   * @param _value The amount of tokens to mint.
   * @return A boolean that indicates if the operation was successful.
   */
  function mint(address _to, uint256 _value) public onlyDealers returns (bool) {
    totalSupply_ = totalSupply_.add(_value);
    balances[_to] = balances[_to].add(_value);
    Mint(msg.sender, _to, _value);
    Transfer(address(0), _to, _value);
    return true;
  }

   /**
   * @dev to burn tokens
   * @param _from The address that will decrease tokens for burn.
   * @param _value The amount of tokens to burn.
   * @return A boolean that indicates if the operation was successful.
   */
  function burn(address _from, uint256 _value) public onlyDealers returns (bool) {
    totalSupply_ = totalSupply_.sub(_value);
    balances[_from] = balances[_from].sub(_value);
    Burn(msg.sender, _from, _value);
    Transfer(_from, address(0), _value);
    return true;
  }

}