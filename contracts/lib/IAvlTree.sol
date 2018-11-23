pragma solidity ^0.4.24;

interface AvlTree {
function insert(uint256 value) public returns();
function remove(uint256 value) public;
function search(uint256 value) public view;
}