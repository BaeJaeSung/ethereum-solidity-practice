pragma solidity ^0.4.11;

contract voteContract{
    mapping (address => bool) voters; // 계정당 한 번의 투표만 가능
    mapping (string => uint) candidates; // 후보자 득표 수
    mapping (uint8 => string) candidateList; // 후보자 리스트

    uint8 numberOfCandidates; // 총 후보자 수
    address contractOwner;

    function voteContract() {
        // 컨트랙트를 생성한 사람이 contractOwner
        contractOwner = msg.sender;
    }

    // 후보자 추가
    function addCandidate(string cand) {
        bool add = true;
        for (uint8 i = 0; i < numberOfCandidates; i++) {
            if(sha3(candidateList[i]) == sha3(cand)) {
                add = false; 
                break;
            }
        }

        if (add) {
            candidateList[numberOfCandidates] = cand;
            numberOfCandidates++;
        }
    }

    function vote(string cand) {
        if (voters[msg.sender]) {}
        else{
            voters[msg.sender] = true;
            candidates[cand]++;
        }
    }

    function alreadyVoted() constant returns (bool) {
        if (voters[msg.sender])
            return true;
        else
            return false;
    }

    function getNumOfCandidates() constant returns (uint8) {
        return numberOfCandidates;
    }

    function getCandidateString(uint8 number) constant returns(string) {
        return candidateList[number];
    }

    function getScore(string cand) constant returns(uint) {
        return candidates[cand];
    }

    function killContract() {
        if (contractOwner == msg.sender)
            selfdestruct(contractOwner);
    }
}