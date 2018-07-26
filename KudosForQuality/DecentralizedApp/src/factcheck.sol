pragma solidity ^0.4.20;

contract WorkbenchBase {
    event WorkbenchContractCreated(string applicationName, string workflowName, address originatingAddress);
    event WorkbenchContractUpdated(string applicationName, string workflowName, string action, address originatingAddress);

    string internal ApplicationName;
    string internal WorkflowName;

    function WorkbenchBase(string applicationName, string workflowName) internal {
        ApplicationName = applicationName;
        WorkflowName = workflowName;
    }

    function ContractCreated() internal {
        WorkbenchContractCreated(ApplicationName, WorkflowName, msg.sender);
    }

    function ContractUpdated(string action) internal {
        WorkbenchContractUpdated(ApplicationName, WorkflowName, action, msg.sender);
    }
}

contract PublishArticle is WorkbenchBase('factcheck', 'PublishArticle') {

	//Set of States
    enum StateType { Nominated, Score_Passed, Score_Failed, Review_Denied, Read, ReadPaid }

    //List of properties
    StateType public State;
    address public Author;
    address public Admin;
	address public Banker;
	address public Subscriber;

    string public ArticleTitle;
    string public ArticleUrl;

	// constructor function
    function PublishArticle(string articleTitle, string articleUrl) public
    {
        Author = msg.sender;
        ArticleTitle = articleTitle;
		ArticleUrl = articleUrl;
        State = StateType.Nominated;

        // call ContractCreated() to create an instance of this workflow
        ContractCreated();
    }

	function SendArticle(string articleTitle, string articleUrl) public
    {
        if (Author != msg.sender)
        {
            revert();
        }

        ArticleTitle = articleTitle;
		ArticleUrl = articleUrl;
        State = StateType.Nominated;

        // call ContractUpdated() to record this action
        ContractUpdated('SendArticle');
    }

	function AcceptReview() public
    {
        Admin = msg.sender;
		State = StateType.Score_Passed;
		
        // call ContractUpdated() to record this action
        ContractUpdated('AcceptReview');
    }

	function RejectReview() public
    {
        Admin = msg.sender;

		State = StateType.Review_Denied;
		
        // call ContractUpdated() to record this action
        ContractUpdated('RejectReview');
    }

	function RejectScore() public
    {
       Admin = msg.sender;

		State = StateType.Score_Failed;
		
        // call ContractUpdated() to record this action
        ContractUpdated('RejectScore');
    }

	function ReadArticle() public
 	{
		Subscriber = msg.sender;

		State = StateType.Read;

		ContractUpdated('ReadArticle');
	}

	function PayAuthor() public
	{
		Banker = msg.sender;
		
		State = StateType.ReadPaid;

		ContractUpdated('PayAuthor');
	}



}