pragma solidity ^0.4.11;

contract SumExample{
    function operation(uint a, uint b) returns (uint result){
        result = sum(a, b);
    }

    function sum(uint a, uint b) returns (uint) {
        uint result = a + b;
        return result;
    }
}