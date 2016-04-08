
contract registry { 
    address public admin; 
    mapping (address => bool) shareholder;
    mapping (uint => address) list;
    bool public state = false; 
    uint no =0;
    function init( ) {
        if (state == false){    state = true;     admin = msg.sender;
        }else { throw;} 
    } 
    function register ( address ne) {    if (admin == msg.sender) {     shareholder[ne] = true;   no = no+1; list[no] =ne; }    else { throw; }    }
    function check( address chk) returns (bool val){    val = shareholder[chk];     }
    function remove (address rmv)  { if (admin == msg.sender) { shareholder[rmv] = false; }  else { throw; } }
    function check_no( uint chk) returns (address addr){    
        if (admin == msg.sender) {    addr = list[chk];    }
	else { throw;  }    }
}

