# Blockchain-Based Vendor Supplier Performance Management

A comprehensive blockchain solution for managing vendor relationships, performance assessments, contracts, and payments using Clarity smart contracts on the Stacks blockchain.

## Overview

This system provides a decentralized approach to vendor management with the following key features:

- **Procurement Department Verification**: Validates and manages procurement departments
- **Vendor Assessment**: Tracks and evaluates vendor performance metrics
- **Contract Management**: Handles vendor contracts and milestones
- **Payment Processing**: Manages invoicing and payment workflows
- **Relationship Optimization**: Optimizes vendor relationships and provides insights

## Architecture

The system consists of five main smart contracts:

### 1. Procurement Verification Contract (`procurement-verification.clar`)
- Registers and verifies procurement departments
- Manages department administrators
- Tracks verification status

### 2. Vendor Assessment Contract (`vendor-assessment.clar`)
- Registers vendors in the system
- Collects performance assessments
- Calculates average performance scores
- Tracks quality, delivery, and communication metrics

### 3. Contract Management Contract (`contract-management.clar`)
- Creates and manages vendor contracts
- Tracks contract milestones
- Updates contract status
- Manages contract lifecycle

### 4. Payment Processing Contract (`payment-processing.clar`)
- Creates and manages invoices
- Processes payments
- Tracks payment history
- Handles invoice approvals

### 5. Relationship Optimization Contract (`relationship-optimization.clar`)
- Manages vendor relationships
- Tracks collaboration levels
- Identifies preferred vendors
- Records optimization metrics

## Getting Started

### Prerequisites

- Stacks blockchain node or testnet access
- Clarity CLI tools
- Node.js and npm for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd blockchain-vendor-management
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts to Stacks testnet:

\`\`\`bash
# Deploy procurement verification contract
clarinet deploy --testnet contracts/procurement-verification.clar

# Deploy other contracts in order
clarinet deploy --testnet contracts/vendor-assessment.clar
clarinet deploy --testnet contracts/contract-management.clar
clarinet deploy --testnet contracts/payment-processing.clar
clarinet deploy --testnet contracts/relationship-optimization.clar
\`\`\`

## Usage Examples

### Register a Procurement Department

\`\`\`clarity
(contract-call? .procurement-verification register-department "IT Procurement" 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
\`\`\`

### Register a Vendor

\`\`\`clarity
(contract-call? .vendor-assessment register-vendor "TechCorp Solutions" 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG)
\`\`\`

### Submit Vendor Assessment

\`\`\`clarity
(contract-call? .vendor-assessment submit-assessment u1 u85 u90 u88 "Excellent delivery and communication")
\`\`\`

### Create a Contract

\`\`\`clarity
(contract-call? .contract-management create-contract u1 "Software Development" "Custom software solution" u50000 u1000 u2000)
\`\`\`

### Process Payment

\`\`\`clarity
(contract-call? .payment-processing process-payment u1 "tx-hash-abc123")
\`\`\`

## Data Structures

### Vendor Information
- ID, name, contact principal
- Performance scores and assessment count
- Status (active, inactive, suspended)

### Contracts
- Vendor ID, title, description
- Value, start/end dates
- Status and milestones

### Assessments
- Quality, delivery, communication scores
- Overall score calculation
- Comments and timestamps

### Payments
- Invoice details and amounts
- Payment status and history
- Transaction references

## Security Features

- Principal-based access control
- Contract owner permissions
- Input validation and error handling
- Immutable transaction records

## Testing

The project includes comprehensive test suites using Vitest:

- Unit tests for all contract functions
- Mock implementations for blockchain interactions
- Coverage for success and error scenarios

Run tests with:
\`\`\`bash
npm test
\`\`\`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions or support, please open an issue in the repository or contact the development team.
\`\`\`

## Roadmap

- [ ] Integration with external payment systems
- [ ] Advanced analytics and reporting
- [ ] Mobile application interface
- [ ] Multi-signature contract approvals
- [ ] Automated compliance checking
  \`\`\`
