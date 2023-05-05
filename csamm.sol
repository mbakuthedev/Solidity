pragma solidity >=0.7.0 <0.9.0;

import "./IERC20.sol";

contract CSAMM{
    IERC20 public immutable token0;
    IERC20 public immutable token1;
    uint public reserve0;
    uint public reserve1;
    uint public totalSupply;
    mapping(address => uint ) public balanceOf;
    constructor(address _token0, address _token1){
        token0 = IERC20(_token0) ;
        token1 = IERC20(_token1);
    }
    function _mint(address _to, uint amount) private {
        balanceOf[_to] += amount;
        totalSupply += amount;
    }
    function _burn(address _from, uint amount) private{
        balanceOf[_from] -= amount;
        totalSupply -= amount;
    }
    function update (uint res0, uint res1) private{
        reserve0 = res0;
        reserve1 = res1;
    }
    function swap(address _tokenIn, uint _amountIn) external returns(uint _amountOut){
        require(_tokenIn == address(token0) || _tokenIn == address(token1), "Invalid Token");
        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint reserveIn, uint reserveOut) = isToken0 
         ? (token0, token1, reserve0, reserve1) :
          (token1, token0, reserve1, reserve0);
        //Transfer Token In
        tokenIn.transferFrom(msg.sender, address(this), _amountIn);
        uint amountIn = tokenIn.balanceOf(address(this)) - reserveIn;
        _amountOut = (amountIn * 997)/1000;
        //Updating Reserves
        (uint res0, uint res1) = isToken0 
        ? (reserveIn + _amountIn, reserveOut - _amountOut)
        : (reserveOut - _amountOut, reserveIn + amountIn);
        update(res0, res1);
        tokenOut.transfer(msg.sender, _amountOut);
    }
    function AddLiquidity(uint _amount0, uint _amount1) external returns(uint shares){
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);
        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));
        //Getting the amount of tokens that came in
        uint d0 = bal0 - reserve0;
        uint d1 = bal1 - reserve1;
        if(totalSupply == 0){
            shares = d0 + d1;
        }
        else{
            shares = ((d0 + d1) * totalSupply / (reserve0 + reserve1));
        }
        require(shares > 0, "Share = 0");
        _mint(msg.sender, shares);
        update(bal0, bal1);
    }
    function RemoveLiquidity(uint shares) external returns(uint d0, uint d1){
        d0 = (reserve0 * shares)/ totalSupply;
        d1 = (reserve1 * shares) / totalSupply;
        _burn(msg.sender, shares);
        update(reserve0 - d0, reserve1 - d1);
        if(d0 > 0){
            token0.transfer(msg.sender, d0);
        }else{
            token1.transfer(msg.sender, d1);
        }
    }

}