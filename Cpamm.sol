// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "./IERC20.sol";
contract CPAMM{
    IERC20 public immutable token0;
    IERC20 public immutable token1;
    constructor(address _token0, address _token1){
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }
    //State Variables
    uint public reserve0;
    uint public reserve1;
    uint  public totalSupply;
    mapping (address => uint) public balanceOf;

    //Internal functions
    function mint (address _to, uint amount) private {
        totalSupply += amount;
        balanceOf[_to] += amount;
        
    }
    function burn(address _from, uint amount) private{
        totalSupply -= amount;
        balanceOf[_from] -= amount;
    }
    function Update(uint _reserve0, uint _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }
     function _sqrt(uint y) private pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
    //We are still going to use the min function
    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }
    //External functions
    function Swap(address _tokenIn, uint amountIn) external returns(uint amountOut){
        require(_tokenIn == address(token0) || _tokenIn == address(token1), "Invalid token");
        //Pulling the token In
        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn,  IERC20 tokenOut, uint reserveIn, uint reserveOut) = isToken0 ?
        (token0, token1, reserve0, reserve1): (token1, token0, reserve1, reserve0);
        tokenIn.transferFrom(msg.sender, address(this), amountIn);

        //Calculated fees
        uint amountInWithFees = (amountIn * 997)/ 1000;
        amountOut = (reserveOut * amountInWithFees)/ (reserveIn + amountInWithFees);

        //Transferring the token out 
        tokenOut.transfer(msg.sender, amountOut);

        //Updating reserves
        //Writing an internal function to update the reserves
        Update(
            token0.balanceOf(address(this)), 
            token1.balanceOf(address(this))
        );


    }
    function AddLiquidity(uint _amount0, uint _amount1) external returns (uint shares){
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);
        if(reserve0 > 0 || reserve1 > 0){
        
            require(reserve0 * _amount1 == reserve1 * _amount1);

        }
        if (totalSupply == 0){
            shares = _sqrt(_amount0 * _amount1);
            //sqrt is an internal function , but ill look for it on the internet
            // It just finds the square root the numbers
            
        }
        else{
            //Min basically gets the minimum of two numbers
            shares = _min(
                (_amount0 * totalSupply) / reserve0,
                (_amount1 * totalSupply) / reserve1
            );
        }
        require(shares > 0, "shares  = 0");
        mint(msg.sender, shares);
        Update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );
    }
    function RemoveLiquidity(uint shares) external returns(uint _amount0, uint _amount1){
        //Calculating the amount that should be withdrawn
        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));
        _amount0 = (shares * bal0)/totalSupply;
        _amount1 = (shares * bal1) / totalSupply;
        require(_amount0 > 0 && _amount1 > 0, "amount0 or amount1 = 0");
        burn(msg.sender, shares);
        Update(
            bal0 - _amount0,
            bal1 - _amount1
        );
        token0.transfer(msg.sender, _amount0);
        token1.transfer(msg.sender, _amount1);
    }

   

   
}
