public with sharing class PricingService {
    public static Decimal calculateFinancingTotalValue(Decimal downPayment, Integer months, Decimal proposedPrice) {
        if (proposedPrice == null || proposedPrice <= 0 || downPayment == null || months == null) {
            throw new AuraHandledException('Parâmetros de entrada inválidos para o cálculo.');
        }

        if(downPayment >= proposedPrice) {
            System.debug(proposedPrice.setScale(2));
            return 0.00;
        }

        Decimal totalPrice = proposedPrice - downPayment;
        Decimal proposedPrice60Percent = proposedPrice * 0.60;

        // Custom metadata com valores de juros
        Map<String, InterestTable__mdt> allRates = InterestTable__mdt.getAll();
        InterestTable__mdt interestTable;
        for(InterestTable__mdt rate : allRates.values()) {
            if(rate.Term__c == String.valueOf(months)) {
                interestTable = rate;
                break;
            }
        }

        if(interestTable == null) {
            throw new AuraHandledException('Não foi encontrado nenhuma tabela de juros para financiamento de ' + months + ' meses');
        }

        Decimal interestPerMonth = downPayment >= proposedPrice60Percent 
        ? interestTable.Level2Rate__c / 100 
        : interestTable.Level1Rate__c / 100;
        
        Decimal totalInterest = totalPrice * interestPerMonth * months;
        Decimal finalPrice = totalPrice + totalInterest;

        System.debug(finalPrice.setScale(2));
        return finalPrice.setScale(2);
    }

    public static Decimal calculateDiscount(Decimal proposedPrice, Decimal discount) {
        return proposedPrice - (proposedPrice * (discount / 100));
    }

}