@isTest
public with sharing class CarServiceTest {

    @isTest
    public static void getCarDetails_ValidFipeAndMatchingYear_ReturnsParsedPriceAndSuccess() {
        // Arrange: CarService vai chamar nosso Request, que fará callout. Logo, precisamos Mockar a chamada (status 200).
        Test.setMock(HttpCalloutMock.class, new FIPEMock(200));

        CarService.CarRequest req = new CarService.CarRequest();
        req.fipeCode = '001494-0';
        req.modelYear = '2026'; // Mes exato do mock "anoModelo"

        // Act
        Test.startTest();
        List<CarService.CarResponse> responses = CarService.getCarDetails(new List<CarService.CarRequest>{ req });
        Test.stopTest();

        // Assert
        System.assertEquals(1, responses.size(), 'Deve retornar uma Invocable response');
        System.assertEquals(true, responses[0].isSuccess, 'Deve encontrar o ano exigido e setar success como true');
        System.assertEquals(80612.00, responses[0].fipeReferencePrice, 'A classe deve limpar "R$" e pontos e retornar 80612.00 Decimal');
        System.assertEquals(null, responses[0].errorMessage, 'Não deve haver mensagem de erro');
    }

    @isTest
    public static void getCarDetails_ApiError_ReturnsFailureAndPropagatesMessage() {
        // Arrange: Simulando erro de API FIPE código inválido (400)
        Test.setMock(HttpCalloutMock.class, new FIPEMock(400));

        CarService.CarRequest req = new CarService.CarRequest();
        req.fipeCode = 'codigo_invalido';
        req.modelYear = '2026';

        // Act
        Test.startTest();
        List<CarService.CarResponse> responses = CarService.getCarDetails(new List<CarService.CarRequest>{ req });
        Test.stopTest();

        // Assert
        System.assertEquals(1, responses.size(), 'Deve retornar uma Invocable response');
        System.assertEquals(false, responses[0].isSuccess, 'O isSuccess deve ficar como false pois a FIPERequest mapeou a "message"');
        System.assertEquals('Código fipe inválido', responses[0].errorMessage, 'A mensagem de erro propagada no DTO deve chegar na tela do Flow via errorMessage');
    }

    @isTest
    public static void getCarDetails_NullModelYear_ThrowsExceptionAndReturnsAsErrorMessage() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new FIPEMock(200));

        CarService.CarRequest req = new CarService.CarRequest();
        req.fipeCode = '001494-0';
        req.modelYear = null; // Passando null de propósito para causar uma NullPointerException

        // Act
        Test.startTest();
        List<CarService.CarResponse> responses = CarService.getCarDetails(new List<CarService.CarRequest>{ req });
        Test.stopTest();

        // Assert: Verifica se a CarService capturou o erro imprevisível do null e não quebrou o Flow
        System.assertEquals(1, responses.size(), 'A classe deve capturar o erro e retornar a lista normalmente');
        System.assertEquals(false, responses[0].isSuccess, 'O isSuccess deve chegar falso do Catch');
        System.assert(responses[0].errorMessage.contains('null'), 'A mensagem do sistema gerada (Argument cannot be null) deve estar no errorMessage');
    }
}