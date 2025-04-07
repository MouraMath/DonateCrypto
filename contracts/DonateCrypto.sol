// SPDX-License-Identifier: MIT

pragma solidity ^ 0.8.17;

struct Campaign {
    address author;
    string title;
    string description;
    string videoUrl;
    string imageUrl;
    uint256 balance;
    bool active;
}

contract DonateCrypto{

    uint256 public donateFee = 100;//taxa fixa por campanha / wei(menor fração do ether["centavos"], 18 casas após a vírgula
    uint256 public nextId = 0;

    mapping(uint256 => Campaign) public campaigns; //campaignId => campanha

    function addCampaign(
        string calldata title,
        string calldata description,         
        string calldata videoUrl,
        string calldata imageUrl)
         public{
            Campaign memory newCampaign;
            newCampaign.title = title;
            newCampaign.description = description;
            newCampaign.videoUrl = videoUrl;
            newCampaign.imageUrl = imageUrl;            
            newCampaign.author = msg.sender;
            newCampaign.active = true;


            nextId++;
            campaigns[nextId] = newCampaign;        
    }

    function donate(uint256 campaignId) public payable{
        require(msg.value>0, "You must send a donation value > 0");
        require(campaigns[campaignId].active == true, "Cannot donate to this campaign");

        campaigns[campaignId].balance += msg.value;
    }


    function withdraw(uint256 campaignId) public{

        Campaign memory campaign = campaigns[campaignId];
        require(campaign.author == msg.sender, "You do not have permission");
        require(campaign.active == true, "This campaign has ended.");
        require(campaign.balance>donateFee, "This campaing does not have enought balance to withdraw");

        address payable recipient = payable(campaign.author);
        recipient.call{value: campaign.balance - donateFee}("");

    

        campaigns[campaignId].active = false;

    }


}




