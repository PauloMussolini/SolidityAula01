pragma solidity 0.5.9;

contract Aluguel{
    
    string public houseAddress;
    address payable public locador; 
    address locatario;
    uint256 public rentValue ;
    struct  Imovel {
        string cidade;
        uint quartos;
    }
    Imovel public imovel;
    
    struct PaymentReceipt {
        uint256 paymentDate;
        uint256 paymentValue;
    }
    PaymentReceipt[] public paymentReceipts;
    
    mapping(uint => PaymentReceipt) public mPaymentReceipts;
    
    event aluguelReajustado (uint256 novoValor);
    
    modifier somenteLocador() {
        require(msg.sender == locador,'Somente o Locador pode executar esta operação');
        _;
    }
    
    constructor (string memory _houseAddress, address payable _locador, address _locatario, uint256 _rentValue) public {
        houseAddress = _houseAddress;
        locador = _locador;
        locatario = _locatario;
        rentValue = _rentValue;
        imovel = Imovel("Xique-Xique",3);
    }
    
    function getLocatarioName() public somenteLocador view returns (address) {
        return locatario;
    }
    
    function setAluguelValue (uint _indice) public somenteLocador returns (uint256){
        rentValue = rentValue + ((rentValue * _indice)/100);
        emit aluguelReajustado(rentValue);
        return rentValue;
    }
    
    function pagamentoAluguel () public payable returns(bool){
        require(msg.sender == locatario, 'Somente Locatário pode pagar aluguel');
        require(msg.value < rentValue, 'Valor abaixo do aluguel');
        PaymentReceipt memory receipt;
        receipt = PaymentReceipt(now, msg.value);
        locador.transfer(rentValue);
        paymentReceipts.push(receipt);
        mPaymentReceipts[paymentReceipts.length] = receipt;  
         
        return true;
    }
}
