public class SubmitApproval {

    public static void submitRequestApproval(Id cardId) {

        Approval.ProcessSubmitRequest request = new Approval.ProcessSubmitRequest();
        request.setObjectId(cardId);
        request.setSubmitterId(UserInfo.getUserId());
        Approval.process(request);
    }

}