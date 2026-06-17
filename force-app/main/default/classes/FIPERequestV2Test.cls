@IsTest
public with sharing class FIPERequestV2Test {
    
    @isTest
    public static void getCarPriceByFipeValidCodeReturnsDecimal() {
        // Arrange: Dizemos ao Salesforce para interceptar a requisição HTTP e usar o nosso Mock de sucesso (200)
        Test.setMock(HttpCalloutMock.class, new FIPEMockV2(200));
        
        // Act: Executa o código que faz a callout
        Test.startTest();
        Decimal priceCar = FIPERequestV2.getCarPriceByFipe('001494-0', '2026');
        Test.stopTest();
        
        // Assert: Verifica se a lista não está vazia e se mapeou os campos do JSON corretamente do Mock
        System.assertEquals(81249, priceCar, 'O valor deve ser 81249, condizente com o mock');
    }

    @isTest
    public static void getCarPriceByFipeInvalidCodeReturnsDecimal() {
        // Arrange: Dizemos ao Salesforce para interceptar a requisição HTTP e usar o nosso Mock de sucesso (200)
        Test.setMock(HttpCalloutMock.class, new FIPEMockV2(422));

        Exception e;
        // Act: Executa o código que faz a callout
        try {
            Test.startTest();
            Decimal priceCar = FIPERequestV2.getCarPriceByFipe('001494-39', '2026');
            Test.stopTest();
        } catch (Exception exc) {
            e = exc;
        }
        
        // Assert: Verifica se a lista não está vazia e se mapeou os campos do JSON corretamente do Mock
        System.assert(e != null, 'O valor deve ser 81249, condizente com o mock');
    }

     @isTest
    public static void getCarPriceByFipeValidCodeAndReturnsError() {
        // Arrange: Dizemos ao Salesforce para interceptar a requisição HTTP e usar o nosso Mock de sucesso (200)
        Test.setMock(HttpCalloutMock.class, new FIPEMockV2(200));

        Exception e;
        // Act: Executa o código que faz a callout
        try {
            Test.startTest();
            Decimal priceCar = FIPERequestV2.getCarPriceByFipe('001494-39', '1500');
            Test.stopTest();
        } catch (Exception exc) {
            e = exc;
        }
        
        // Assert: Verifica se a lista não está vazia e se mapeou os campos do JSON corretamente do Mock
        System.assert(e != null, 'O valor deve ser 81249, condizente com o mock');
    }

    @isTest
    public static void getCarPriceByFipeCalloutExceptionThrown() {
        // Arrange: Passa 500 para fazer o Mock lançar uma CalloutException
        Test.setMock(HttpCalloutMock.class, new FIPEMockV2(500));
        // Act & Assert
        try {
            Test.startTest();
            Decimal priceCar = FIPERequestV2.getCarPriceByFipe('001494-0', '2026');
            Test.stopTest();
            
            System.assert(false, 'Uma FipeRequestException era esperada devido à falha de conexão.');
        } catch (FIPERequestV2.FipeRequestException e) {
            // Assert: Garante que a exceção de envio foi convertida corretamente na sua FipeRequestException
            System.assert(e.getMessage().contains('Não foi possível consultar a API de tabela FIPE: Timeout simulado pelo Mock'), 
                        'A mensagem da exceção está incorreta: ' + e.getMessage());
        }
    }
}