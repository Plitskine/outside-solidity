// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Twitter {

    // 1 -------------- Account creation
    struct User {
        address wallet;
        string name;
        string bio;
    }

    mapping(address => User) private users;

    /**
     * @dev Store value in variable.
     *
     * @param _name username
     * @param _bio short user presentation 
     */
    function createAccount(string memory _name, string memory _bio) public {
        // Do not create if user does not exists.
        require(!userExists(msg.sender), "User exists !");

        // Caller is msg.sender.
        User memory _user = User(msg.sender, _name, _bio);
        
        // Use the wallet address as key for indexing.
        users[msg.sender] = _user;
    }


    /**
     * @dev Check if a user exists.
     *
     * @param _wallet the wallet to look for
     */
    function userExists(address _wallet) internal view returns (bool) {
        return users[_wallet].wallet != address(0x0);
    }

    // 2 ------------------- Get account details
    function getUserDetails(address _wallet) public view returns (User memory _user) {
        _user = users[_wallet];

        require(_user.wallet != address(0), "User not found !");
    }

    function getUserDetails2(address _wallet) public view returns (string memory, string memory) {
        User memory _user = users[_wallet];

        return (_user.name, _user.bio);
    }

    // 3 ------------- Tweet !
    struct Tweet {
        uint256 id;
        string message;
        uint256 timestamp;
        address userWallet;
    }

    Tweet[] private tweets;

    /**
     * @dev Return value 
     * @return tweet id (ie position in the tweets array)
     */
    function tweet(string memory _message) public returns (uint256) {
        // TODO : premium !

        // Make sure current user has an account.
        if (!userExists(msg.sender)) {
            revert("Can not tweet without an account !");
        }

        // Not empty string.
        bytes memory _is_not_empty = bytes(_message);
        require(_is_not_empty.length > 0, "Tweet something ! Duh !");

        // TODO : Limit to 140 characters ?

        // Get the tweet id from the total count of tweets + 1.
        uint256 _id = countTweets() + 1;

        // Create the tweet struct.
        Tweet memory _tweet = Tweet(_id, _message, block.timestamp, msg.sender);

        // Store it
        tweets.push(_tweet);

        return _id;
    }

    function countTweets() public view returns (uint256) {
        return tweets.length;
    }

    function listTweets() public view returns (Tweet[] memory) {
       return tweets;
    }

}