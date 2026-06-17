@isTest
public with sharing class FIPERequestTest {

    @isTest
    public static void getCarPriceByFipeValidCodeReturnsCarDTOList() {
        // Arrange: Dizemos ao Salesforce para interceptar a requisição HTTP e usar o nosso Mock de sucesso (200)
        Test.setMock(HttpCalloutMock.class, new FIPEMock(200));
        
        // Act: Executa o código que faz a callout
        Test.startTest();
        List<FIPERequest.CarDTO> result = FIPERequest.getCarPriceByFipe('001494-0');
        Test.stopTest();
        
        // Assert: Verifica se a lista não está vazia e se mapeou os campos do JSON corretamente do Mock
        System.assertEquals(1, result.size(), 'Deve retornar um veículo na lista');
        System.assertEquals('R$ 80.612,00', result[0].valor, 'O valor FIPE mapeado deve ser igual ao do Mock');
        System.assertEquals('Fiat', result[0].marca, 'A marca mapeada deve ser Fiat');
        System.assertEquals(2026, result[0].anoModelo, 'O ano deve ser 2026 em formato Integer');
        System.assertEquals(null, result[0].message, 'Não deve mapear mensagem de erro no cenário de sucesso');
    }

    @isTest
    public static void getCarPriceByFipeInvalidCodeReturnsListWithErrorMessage() {
        // Arrange: Vamos forçar a resposta da API ser o status 400 simulando erro
        Test.setMock(HttpCalloutMock.class, new FIPEMock(400));
        
        // Act
        Test.startTest();
        List<FIPERequest.CarDTO> result = FIPERequest.getCarPriceByFipe('000000-0');
        Test.stopTest();
        
        // Assert: Verifica se a classe conseguiu ler o JSON de erro (que não era ArrayList) e devolveu dentro do DTO de forma tratada no else
        System.assertEquals(1, result.size(), 'Em caso de erro conhecido, a classe transforma o erro em um DTO unico dentro da lista');
        System.assertEquals('Código fipe inválido', result[0].message, 'Deve mapear a "message" que a API devolveu no Mock JSON');
        System.assertEquals(null, result[0].valor, 'Valor deve ser nulo pois a API retornou apenas o objeto de erro');
    }

    @isTest
    public static void getCarPriceByFipeExceptionThrownReturnsListWithExceptionMessage() {
        // Arrange: Simulando uma exception usando o nosso status code 500 configurado no Mock
        Test.setMock(HttpCalloutMock.class, new FIPEMock(500));
        
        // Act
        Test.startTest();
        List<FIPERequest.CarDTO> result = FIPERequest.getCarPriceByFipe('timeout-test');
        Test.stopTest();
        
        // Assert: Verifica se caiu no catch e formatou a mensagem perfeitamente
        System.assertEquals(1, result.size(), 'A exception deve gerar um DTO dentro da lista');
        System.assert(result[0].message.contains('Não foi possível encontrar nenhum veículo com o código fipe: timeout-test'), 'A mensagem deve conter o inicio formatado do catch');
        System.assert(result[0].message.contains('Detalhe: Timeout simulado pelo Mock'), 'A mensagem deve repassar o erro original via e.getMessage()');
    }
}