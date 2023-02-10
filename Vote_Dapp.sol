// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vote_Dapp {
    // Estructuras de datos para almacenar información de candidatos
    struct Candidate {
        uint id;
        string name;
        string position;
        string nationality;
        uint voteCount;
    }

    // Mapeo para almacenar información de votantes
    mapping (address => bool) public voters;

    // Array para almacenar información de candidatos
    Candidate[] public candidates;

    // Titular del contrato
    address public owner;

    // Marcar para determinar si la votación ha terminado
    bool public votingEnded = false;

    // Evento para registrar al ganador de la votación
    event Winner(string winnerName);

    // Constructor para establecer el propietario del contrato
    constructor() {
        owner = msg.sender;
    }

    // Función para agregar candidatos
    function addCandidate(string memory _name, string memory _position, string memory _nationality) public {
        require(msg.sender == owner, "Only the contract owner can add candidates.");
        candidates.push(Candidate(candidates.length, _name, _position, _nationality, 0));
    }

    // Función para permitir a los votantes votar por un candidato
    function vote(uint _candidateId) public {
        require(voters[msg.sender] == false, "You have already voted.");
        require(_candidateId < candidates.length, "Invalid candidate.");
        require(votingEnded == false, "Voting has already ended.");

        voters[msg.sender] = true;
        candidates[_candidateId].voteCount ++;
    }

    // Función para finalizar la votación y determinar el ganador
    function endVoting() public {
        require(msg.sender == owner, "Only the contract owner can end voting.");
        require(votingEnded == false, "Voting has already ended.");

        votingEnded = true;

        uint maxVotes = 0;
        uint winnerId = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }

        emit Winner(candidates[winnerId].name);
    }

    // Función para recuperar al ganador de la votación
    function getWinner() public view returns (string memory) {
        require(votingEnded == true, "Voting has not ended.");

        uint maxVotes = 0;
        uint winnerId = 0;

        for (uint i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }

        return candidates[winnerId].name;
    }
}
