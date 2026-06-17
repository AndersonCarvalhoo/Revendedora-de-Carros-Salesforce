public with sharing class FIPERequestV2 {
    public static Decimal getCarPriceByFipe(String fipeCode, String year) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:FipeApi/' + fipeCode);
        request.setMethod('GET');
 
        Http http = new Http();
        HttpResponse response;
        try {
            response = http.send(request);
        } catch (Exception e) {
            throw new FipeRequestException('Não foi possível consultar a API de tabela FIPE: ' + e.getMessage());
        }
        
        if (response.getStatusCode() != 200) {
            FipeApiResponseDTO responseDTO = FipeApiResponseDTO.parse(response.getBody());

            System.debug('Não foi possível consultar o valor da FIPE deste veiculo. Detalhes: ' + responseDTO.message);
            throw new FipeRequestException('Não foi possível consultar o valor da FIPE deste veiculo. Detalhes: ' + responseDTO.message);
        }

        FipeApiResponseDTO responseDTO = FipeApiResponseDTO.parse(response.getBody());
            for(FipeApiResponseDTO.AnnualValue annualValue : responseDTO.years) {
                if (annualValue.model_year.equals(year) && annualValue.price != null) {
                    System.debug(annualValue.price);
                    return annualValue.price;
                }
            }

        System.debug('Não foi possível encontrar algum carro deste ano com referente a tabela fipe');
        throw new FipeRequestException('Não foi possível encontrar algum carro deste ano com referente a tabela fipe');
    }

    public class FipeRequestException extends Exception {}
}