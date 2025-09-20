interface IBalance {
    function deposit() external payable;
    function withdraw(uint256 _amount) external;
}