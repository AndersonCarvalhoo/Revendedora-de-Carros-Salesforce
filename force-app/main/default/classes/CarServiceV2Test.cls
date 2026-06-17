@IsTest
public with sharing class CarServiceV2Test {
    @isTest
    public static void getCarDetailsValidFipe() {
        Test.setMock(HttpCalloutMock.class, new FIPEMockV2(200));

        CarServiceV2.CarRequest request = new CarServiceV2.CarRequest();
        request.fipeCode = '001494-0';
        request.modelYear = '2026';

        Test.startTest();
        List<CarServiceV2.CarResponse> response = CarServiceV2.getCarDetails(new List<CarServiceV2.CarRequest>{ request });
        Test.stopTest();
        
        System.assertEquals(81249, response.get(0).fipeReferencePrice, 'O valor da FIPE do mock deve ser 81249');
        System.assert(response.get(0).isSuccess, 'isSuccess deve ser true');
    }

    @isTest
    public static void getCarDetailsApiErrorReturnsFailure() {
        Test.setMock(HttpCalloutMock.class, new FIPEMockV2(422));

        CarServiceV2.CarRequest request = new CarServiceV2.CarRequest();
        request.fipeCode = '001494-023';
        request.modelYear = '1523';

        Test.startTest();
        List<CarServiceV2.CarResponse> response = CarServiceV2.getCarDetails(new List<CarServiceV2.CarRequest>{ request });
        Test.stopTest();

        System.assert(!response.get(0).isSuccess, 'O isSuccess deve ser false');
        System.assert(response.get(0).errorMessage.contains('Não foi possível consultar o valor da FIPE deste veiculo'), 'Deve conter a mensagem de erro especificada');
    }

}