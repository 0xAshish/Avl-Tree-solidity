pragma solidity ^0.4.24;

import { Math } from "openzeppelin-solidity/contracts/math/Math.sol";
import { IAvlTree } from "./IAvlTree.sol";

// TODO: move recursive to iterative 
// load in memory and do balancing and rewrite tree 
// with just minimum writes can be better 
// deleteNode leaves hole in array :D 
// 


contract AvlTree is IAvlTree {
  struct Node {
    uint256 value;
    uint256 left;
    uint256 right;
    uint256 height;
  }
  
  mapping (uint256 => Node) private tree; 
  uint256 private root = 0;
  uint256 public currentSize = 0;
  
  constructor() public {
		
    // NULL PTR node 
    tree[0] = Node({
      value: 0,
      left: 0,
      right: 0,
      height: 0
      });
    root = 0;
  }
    
  function search(uint256 value) public view returns (bool) {
    require(value > 0);
    if (root == 0) return false;
    return (tree[value].value>0);
  }

  function insert(uint256 value) public returns (uint256) {
    require(value > 0);
    root = _insert(root, value);
    currentSize++;
    return root;
  }
  
  //should return bool ?
  function remove(uint256 value) public {
    require(value > 0);
    root = _remove(root, value);
    currentSize--;
  }

  function getMax() public view returns (uint256) {
    if (root == 0) return 0;
    uint256 _root = root;
    while (tree[_root].right != 0) {
      _root = tree[_root].right;
    }
    return tree[_root].value;
  }
  
  function getMin() public view returns (uint256) {
    if (root == 0) return 0;
    uint256 _root = root;
    while (tree[_root].left != 0) {
      _root = tree[_root].left;
    }
    return tree[_root].value;
  }

  function delMax() public returns (uint256) {
    if (root == 0) return 0;
    uint256 _root = root;
    while (tree[_root].right != 0) {
      _root = tree[_root].right;
    }
    uint256 value = tree[_root].value;
    root = _remove(root, value);
    currentSize--;
    return value;
  }
  
  function delMin() public returns (uint256) {
    if (root == 0) return 0;
    uint256 _root = root;
    while (tree[_root].left != 0) {
      _root = tree[_root].left;
    }
    uint256 value = tree[_root].value;
    root = _remove(root, value);
    currentSize--;
    return value;
  }

  // temp helper function 
  function getChilds(uint256 index) public view  returns (uint256 left, uint256 right) {
    left = tree[index].left;
    right = tree[index].right;
  }

  function getTree() public view returns (address[]) {
    require(root != 0);
    address[] memory _tree = new address[](currentSize);
    uint256 j = 0;
    uint256 value;
    for (uint256 i = 0;i < currentSize;) {
      value = tree[j++].value;
      if (value > 0) {
        value << 160;
        _tree[i++] = address(uint160(value));
      }
    }
    return _tree;
  }

  function getRoot() public view returns(uint256) {
    return tree[root].value;
  }

  function _insert(uint256 _root, uint256 value) private returns (uint256) {
    if (_root == 0) {
      tree[value] = Node({
        value: value,
        left: 0,
        right: 0,
        height: 1
      });
      return value;
    }

    if (value <= tree[_root].value) {
      tree[_root].left = _insert(tree[_root].left, value);
    } else {
      tree[_root].right = _insert(tree[_root].right, value);
    }
    return balance(_root);
  }

  function _remove(uint256 _root, uint256 value) private returns (uint256) {
    uint256 temp;
    if (_root == 0) {
      return _root;
    }
    if (tree[_root].value == value) {
      if (tree[_root].left == 0 || tree[_root].right == 0) {
        if (tree[_root].left == 0) {
          temp = tree[_root].right;
        } else {
          temp = tree[_root].left;
        }
        tree[_root] = tree[0];
        return temp;
      } else {
        for (temp = tree[_root].right; tree[temp].left != 0; temp = tree[temp].left){}
        tree[_root].value = tree[temp].value;
        tree[temp] = tree[0];
        tree[_root].right = _remove(tree[_root].right, tree[temp].value);
        return balance(_root);
  		}
  	}

    if (value < tree[_root].value) {
      tree[_root].left = _remove(tree[_root].left, value);
    } else {
      tree[_root].right = _remove(tree[_root].right, value);
    }
    return balance(_root);
  }

  function rotateLeft(uint256 _root) private returns (uint256)  {
    uint256 temp = tree[_root].left;
    tree[_root].left = tree[temp].right;
    tree[temp].right = _root;
    if (_root > 0) { 
      tree[_root].height = 1 + Math.max256(tree[tree[_root].left].height, tree[tree[_root].right].height);
    }
    if (temp > 0) { 
      tree[temp].height = 1 + Math.max256(tree[tree[temp].left].height, tree[tree[temp].right].height);
    }
    return temp;
  }

  function rotateRight (uint256 _root) private returns (uint256) {
    uint256 temp = tree[_root].right;
    tree[_root].right = tree[temp].left;
    tree[temp].left = _root;
    if (_root > 0) { 
      tree[_root].height = 1 + Math.max256(tree[tree[_root].left].height, tree[tree[_root].right].height);
    }
    if (temp > 0) { 
      tree[temp].height = 1 + Math.max256(tree[tree[temp].left].height, tree[tree[temp].right].height);
    }
    return temp;
  }

  function balance(uint256 _root) private returns (uint256) { 
    if (_root > 0) { 
      tree[_root].height = 1 + Math.max256(tree[tree[_root].left].height, tree[tree[_root].right].height);
    }
    if (tree[tree[_root].left].height > tree[tree[_root].right].height + 1) {		
      if (tree[tree[tree[_root].left].right].height > tree[tree[tree[_root].left].left].height) {
        tree[_root].left = rotateRight(tree[_root].left);
      }
      return rotateLeft(_root);
    } else if (tree[tree[_root].right].height > tree[tree[_root].left].height + 1) {
      if (tree[tree[tree[_root].right].left].height > tree[tree[tree[_root].right].right].height) {
        tree[_root].right = rotateLeft(tree[_root].right);
      }
      return rotateRight(_root);
    }
    return _root;
  }

}
