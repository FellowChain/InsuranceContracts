
pragma solidity ^0.4.23;
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract NameRegistry is Ownable{

  mapping (bytes32 => address) public contracts;
  function setAddress(string _adr,address _cntrct)public onlyOwner{
    require(contracts[keccak256(_adr)]==address(0));
    contracts[keccak256(_adr)]=_cntrct;
  }

  function getAddress(string _adr) view returns(address){
    return contracts[keccak256(_adr)];
  }

}
