pragma solidity ^0.4.24;


contract IAvlTree {

  function insert(uint256 value) public returns(uint256);
  function remove(uint256 value) public;
  function search(uint256 value) public view returns (bool);
}
