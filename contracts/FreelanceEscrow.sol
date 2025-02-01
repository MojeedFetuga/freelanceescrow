// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FreelanceEscrow {
    address public owner;

    enum JobStatus { Pending, Accepted, Completed, Withdrawn }
    
    struct Job {
        address client;
        address freelancer;
        uint256 amount;
        JobStatus status;
    }

    mapping(uint256 => Job) public jobs;
    uint256 public jobCounter;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyClient(uint256 jobId) {
        require(msg.sender == jobs[jobId].client, "Only client can call this function");
        _;
    }

    modifier onlyFreelancer(uint256 jobId) {
        require(msg.sender == jobs[jobId].freelancer, "Only freelancer can call this function");
        _;
    }

    modifier validJob(uint256 jobId) {
        require(jobs[jobId].client != address(0), "Job does not exist");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createJob(address freelancer) external payable {
        require(msg.value > 0, "Payment must be greater than zero");
        require(freelancer != address(0), "Invalid freelancer address");
        
        jobCounter++;
        jobs[jobCounter] = Job(msg.sender, freelancer, msg.value, JobStatus.Pending);
    }

    function acceptJob(uint256 jobId) external onlyFreelancer(jobId) validJob(jobId) {
        require(jobs[jobId].status == JobStatus.Pending, "Job is not pending");
        jobs[jobId].status = JobStatus.Accepted;
    }

    function completeJob(uint256 jobId) external onlyClient(jobId) validJob(jobId) {
        require(jobs[jobId].status == JobStatus.Accepted, "Job is not accepted yet");
        jobs[jobId].status = JobStatus.Completed;
    }

    function withdrawPayment(uint256 jobId) external onlyFreelancer(jobId) validJob(jobId) {
        require(jobs[jobId].status == JobStatus.Completed, "Job is not completed yet");
        
        uint256 amount = jobs[jobId].amount;
        jobs[jobId].status = JobStatus.Withdrawn;
        payable(msg.sender).transfer(amount);
    }
}