// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChainManagmentSmartContract {
    struct Product {
        uint256 id;
        string name;
        uint256 quantity;
        string organicCertification;
        string geolocation;
        ProductStatus status;
        uint256 harvestDate;
    }

    struct Transaction {
        uint256 id;
        uint256 productId;
        TransactionType transactionType;
        uint256 timestamp;
        string location;
        address actorAddress; // Address of the actor involved in the transaction
    }

    struct Actor {
        address actorAddress;
        string role;
    }

    mapping(uint256 => Product) public products;
    mapping(uint256 => Transaction) public transactions;
    Actor[] public actors;

    enum TransactionType {
        Harvest,
        Transport,
        Roast,
        Package,
        Retail
    }

    enum ProductStatus {
        InFarm,
        InTransit,
        Roasted,
        Packaged,
        OnSale
    }

    enum ActorRole {
        Farmer,
        Transporter,
        Roaster,
        Retailer
    }

    uint256 public productId = 0;
    function registerProduct(
        string memory _name,
        uint256 _quantity,
        string memory _organicCertification,
        string memory _geolocation,
        uint256 _harvestDate
    ) public returns (uint256) {
        products[productId] = Product({
            id: productId,
            name: _name,
            quantity: _quantity,
            organicCertification: _organicCertification,
            geolocation: _geolocation,
            status: ProductStatus.InFarm,
            harvestDate: _harvestDate
        });

        productId++;
        return productId - 1; // Return the product ID
    }

    function getProductById(uint256 _productId) public view returns (Product memory) {
        return products[_productId];
    }

    uint256 public transactionId = 0;
    function recordTransaction(
    uint256 _productId,
    TransactionType _transactionType,
    string memory _location
    ) public {
        require(products[_productId].status != ProductStatus.OnSale, "Product is already on sale");

        transactions[transactionId] = Transaction({
            id: transactionId,
            productId: _productId,
            transactionType: _transactionType,
            timestamp: block.timestamp,
            location: _location,
            actorAddress: msg.sender
        });

        transactionId++;
    }

    struct QualityCheck {
        uint256 id;
        uint256 productId;
        uint256 timestamp;
        uint256 moistureContent;
        uint256 beanSize;
    }

    mapping(uint256 => QualityCheck[]) public productQualityChecks;

    function recordQualityCheck(
        uint256 _productId,
        uint256 _moistureContent,
        uint256 _beanSize
    ) public {
        QualityCheck memory newCheck = QualityCheck({
            id: productQualityChecks[_productId].length,
            productId: _productId,
            timestamp: block.timestamp,
            moistureContent: _moistureContent,
            beanSize: _beanSize
        });

        productQualityChecks[_productId].push(newCheck);
    }

    struct Escrow {
        address buyer;
        address seller;
        uint256 amount;
        bool isReleased;
    }

    mapping(uint256 => Escrow) public escrows;
    uint256 public escrowId = 0;

    function createEscrow(address _buyer, uint256 _amount) public payable returns (uint256) {
        require(msg.value == _amount, "Insufficient funds");

        Escrow memory newEscrow = Escrow({
            buyer: _buyer,
            seller: msg.sender,
            amount: _amount,
            isReleased: false
        });

        escrows[escrowId] = newEscrow;
        escrowId++;

        return escrowId - 1;
    }

    function releaseEscrow(uint256 _escrowId) public {
        Escrow storage escrow = escrows[_escrowId];
        require(escrow.seller == msg.sender, "Only seller can release escrow");
        require(!escrow.isReleased, "Escrow already released");

        payable(escrow.seller).transfer(escrow.amount);
        escrow.isReleased = true;
    }
}