// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract AccessControl
{
    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);

    mapping(bytes32 => mapping(address => bool)) public roles;

    bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    bytes32 private constant USER  = keccak256(abi.encodePacked("USER"));

    constructor()
    {
        _grantRole(ADMIN, msg.sender);
    }

    function _grantRole(bytes32 _role, address _account) private 
    {
        roles[_role][_account] = true;
        emit GrantRole(_role,_account);
    }

    function grantRole(bytes32 _role, address _account) external onlyRole(ADMIN)
    {
        _grantRole(_role,_account);
    }

    function revokeRole(bytes32 _role, address _account) external onlyRole(ADMIN)
    {
        roles[_role][_account] = false;
        emit RevokeRole(_role,_account);
    }

    modifier onlyRole(bytes32 _role)
    {
        require(roles[_role][msg.sender], "Not Authorized");
        _;
    }
}