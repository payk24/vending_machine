# Vending Machine
Design a vending machine in code (it should be a CLI interface). The vending machine, once a product is selected and the appropriate amount of money (coins) is inserted, should return that product. It should also return change (coins) if too much money is provided or ask for more money (coins) if there is not enough (change should be as minimum coins as possible and be printed as coin * count).
Keep in mind that you need to manage the scenario where the item is out of stock or the machine does not have enough change to return to the customer.

## Available coins

25c, 50c, 1$, 2$, 3$, 5$

## Getting Started
To get started with the project:

### Prerequisites
Ruby 2.7.2 is required for the project.

### Installation
Clone or download project.

Install Gem dependencies.
```
bundle install
```

To start the vending machine:
```
ruby cli.rb
```

## Running the Tests
Run the tests from the project root folder.
```
rspec
```

## Built With
- Ruby 2.7.2
- tty-prompt, tty-table
- RSpec
