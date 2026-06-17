public with sharing class FinanciamentoAction {

    public class Request {
        @InvocableVariable(label='Preço Total Proposto' required=true)
        public Decimal proposedPrice;
        @InvocableVariable(label='Entrada' required=true)
        public Decimal downPayment;
        @InvocableVariable(label='Prazo de Pagamento (Meses)' required=true)
        public Integer months;
    }

    public class Response {
        @InvocableVariable(label='Valor total do Financiamento')
        public Decimal totalFinancedValue;
        @InvocableVariable(label='Valor das Parcelas')
        public Decimal installmentValues;
        @InvocableVariable
        public Boolean isSuccess;
        @InvocableVariable
        public String errorMessage;
    }

    @InvocableMethod(label='Calcular Valor Total do Financiamento' description='Description' category='Category')
    public static List<Response> executeCalculateFinancingTotalValue(List<Request> requests) {
        List<Response> financingResponses = new List<Response>();

        for(Request req : requests) {
            Response financingResponse = new Response();
            try {
                Decimal totalFinancedValueReq = PricingService.calculateFinancingTotalValue(req.downPayment, req.months, req.proposedPrice);
                financingResponse.totalFinancedValue = totalFinancedValueReq;
                financingResponse.installmentValues = totalFinancedValueReq / req.months;
                financingResponse.isSuccess = true;
            } catch(Exception e) {
                financingResponse.isSuccess = false;
                financingResponse.errorMessage = e.getMessage();
            }
            financingResponses.add(financingResponse);
        }

        return financingResponses;
    }
}