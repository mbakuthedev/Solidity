pragma solidity >=0.7.0 <0.9.0;

contract AccessControl{

    constructor(){
        _grantRole(ADMIN, msg.sender);
    }
    event grantRole(bytes32 indexed role, address indexed account);
    event revokeRole(bytes32 indexed role, address indexed account);

    mapping(bytes32 => mapping(address => bool)) public roles;

    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    bytes32 private constant USER = keccak256(abi.encodePacked("USER"));

    modifier onlyOwner(bytes32 _role){
        require(roles[_role][msg.sender], "not Authorized");
        _;
    }
    function _grantRole(bytes32 _role, address _account) internal {
        roles[_role][_account] = true;
        emit grantRole(_role, _account);
    }
    function _revokeRole(bytes32 _role, address _account) internal{
        roles[_role][_account] = false;
        emit revokeRole(_role, _account);
    }
    function GrantRole(bytes32 _role, address _account) external onlyOwner(ADMIN){
        _grantRole(_role, _account);

    }
    function RevokeRole(bytes32 _role, address _account) external onlyOwner(ADMIN){
        _revokeRole(_role, _account);
    }

    


}