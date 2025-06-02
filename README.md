# Tokenized Community Development Collective Intelligence Governance

A comprehensive blockchain-based governance system built with Clarity smart contracts that enables communities to make collective decisions, allocate resources, and optimize participation through tokenized incentives.

## Overview

This system consists of five interconnected smart contracts that work together to create a robust collective intelligence governance framework:

1. **Community Verification Contract** - Validates and manages collective intelligence communities
2. **Decision Making Protocol Contract** - Handles proposal creation, voting, and execution
3. **Resource Allocation Contract** - Manages community resource distribution
4. **Outcome Measurement Contract** - Tracks and evaluates governance effectiveness
5. **Participation Optimization Contract** - Enhances community engagement through incentives

## Features

### Community Management
- Create and verify communities with customizable verification thresholds
- Member verification system with collective validation
- Community metrics and performance tracking

### Democratic Decision Making
- Proposal creation and management system
- Weighted voting mechanism
- Automatic proposal execution based on voting results
- Time-bound voting periods

### Resource Distribution
- Community resource pools with transparent fund management
- Request-based allocation system with approval workflows
- Real-time tracking of fund distribution and utilization

### Performance Analytics
- Comprehensive outcome measurement and tracking
- Performance history with multiple metrics
- Target-based goal setting and achievement tracking
- Overall performance scoring system

### Engagement Optimization
- Participation scoring and contribution tracking
- Flexible incentive program creation
- Reward distribution system
- Engagement level classification (new, regular, active, expert)

## Smart Contract Architecture

### Community Verification (`community-verification.clar`)
- `create-community`: Create new communities with verification requirements
- `verify-member`: Verify community members through collective validation
- `is-member-verified`: Check member verification status

### Decision Making (`decision-making.clar`)
- `create-proposal`: Submit proposals for community voting
- `cast-vote`: Vote on proposals with weighted voting power
- `execute-proposal`: Execute approved proposals automatically

### Resource Allocation (`resource-allocation.clar`)
- `add-funds`: Add resources to community pools
- `request-allocation`: Request resource allocation for specific purposes
- `approve-allocation`: Approve allocation requests
- `distribute-allocation`: Distribute approved allocations

### Outcome Measurement (`outcome-measurement.clar`)
- `update-metric`: Update community performance metrics
- `record-performance`: Record performance snapshots
- `calculate-performance-score`: Calculate overall performance scores

### Participation Optimization (`participation-optimization.clar`)
- `record-contribution`: Track member contributions
- `create-incentive-program`: Create reward programs
- `distribute-reward`: Distribute rewards to active members

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js for testing

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd collective-intelligence-governance
```

2. Install dependencies:
```bash
npm install
```

3. Run tests:
```bash
npm test
```

### Deployment

Deploy contracts to Stacks blockchain:

```bash
# Deploy community verification contract
clarinet deploy contracts/community-verification.clar

# Deploy decision making contract
clarinet deploy contracts/decision-making.clar

# Deploy resource allocation contract
clarinet deploy contracts/resource-allocation.clar

# Deploy outcome measurement contract
clarinet deploy contracts/outcome-measurement.clar

# Deploy participation optimization contract
clarinet deploy contracts/participation-optimization.clar
```

## Usage Examples

### Creating a Community
```clarity
(contract-call? .community-verification create-community "Tech Innovators" u3)
```

### Creating a Proposal
```clarity
(contract-call? .decision-making create-proposal 
  "Upgrade Infrastructure" 
  "Proposal to upgrade community infrastructure" 
  u1 
  u144) ;; 144 blocks voting period
```

### Requesting Resource Allocation
```clarity
(contract-call? .resource-allocation request-allocation 
  u1 
  u1000 
  "Community event funding")
```

## Testing

The project includes comprehensive Vitest-based tests for all contract functions. Tests cover:

- Contract deployment and initialization
- Function execution and error handling
- State management and data integrity
- Integration between contracts

Run tests with:
```bash
npm test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## Security Considerations

- All contracts include proper authorization checks
- Input validation prevents invalid data entry
- State management ensures data consistency
- Error handling provides clear feedback

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support, please open an issue in the GitHub repository.
