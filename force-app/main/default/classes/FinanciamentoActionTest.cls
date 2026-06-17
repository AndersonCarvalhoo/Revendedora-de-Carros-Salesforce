@IsTest
public with sharing class FinanciamentoActionTest {

    @isTest
    public static void calculateFinancingValidParamsReturnsSuccess() {
        List<FinanciamentoAction.Request> requests = new List<FinanciamentoAction.Request>();
        FinanciamentoAction.Request request = new FinanciamentoAction.Request();
        request.proposedPrice = 100000;
        request.downPayment = 10000;
        request.months = 12;
        requests.add(request);

        Test.startTest();
            List<FinanciamentoAction.Response> responses = FinanciamentoAction.executeCalculateFinancingTotalValue(requests);
        Test.stopTest();

        System.assertEquals(1, responses.size());
        System.assert(responses[0].isSuccess);
    }

    @isTest
    public static void calculateFinancingNullParamsReturnsError() {
        List<FinanciamentoAction.Request> requests = new List<FinanciamentoAction.Request>();
        FinanciamentoAction.Request request = new FinanciamentoAction.Request();
        request.proposedPrice = null;
        request.downPayment = null;
        request.months = null;
        requests.add(request);

        Test.startTest();
            List<FinanciamentoAction.Response> responses = FinanciamentoAction.executeCalculateFinancingTotalValue(requests);
        Test.stopTest();

        System.assertEquals(1, responses.size());
        System.assert(!responses[0].isSuccess);
    }

    @isTest
    public static void calculateFinancingHighDownPaymentReturnsSuccess() {
        List<FinanciamentoAction.Request> requests = new List<FinanciamentoAction.Request>();
        FinanciamentoAction.Request request = new FinanciamentoAction.Request();
        request.proposedPrice = 100000;
        request.downPayment = 120000; // Maior que o proposedPrice
        request.months = 12;
        requests.add(request);

        Test.startTest();
            List<FinanciamentoAction.Response> responses = FinanciamentoAction.executeCalculateFinancingTotalValue(requests);
        Test.stopTest();

        System.assertEquals(1, responses.size());
        System.assert(responses[0].isSuccess);
    }

    @isTest
    public static void calculateFinancingInvalidMonthReturnsError() {
        List<FinanciamentoAction.Request> requests = new List<FinanciamentoAction.Request>();
        FinanciamentoAction.Request request = new FinanciamentoAction.Request();
        request.proposedPrice = 100000;
        request.downPayment = 10000;
        request.months = 13;
        requests.add(request);

        Test.startTest();
            List<FinanciamentoAction.Response> responses = FinanciamentoAction.executeCalculateFinancingTotalValue(requests);
        Test.stopTest();

        System.assertEquals(1, responses.size());
        System.assert(!responses[0].isSuccess);
    }
    
}