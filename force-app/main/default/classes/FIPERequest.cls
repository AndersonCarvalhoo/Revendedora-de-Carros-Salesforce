public with sharing class FIPERequest {
    public static List<CarDTO> getCarPriceByFipe(String fipeCode) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:BrasilApi/' + fipeCode);
        request.setMethod('GET');
 
        List<CarDTO> responseCar = new List<CarDTO>();
        Http http = new Http();
        try {
            HttpResponse response = http.send(request);
 
            if (response.getStatusCode() == 200) {
                List<CarDTO> responseListCars = (List<CarDTO>) JSON.deserialize(response.getBody(), List<CarDTO>.class);
                responseCar = responseListCars;
                System.debug(responseListCars);
                System.debug('teste');
            } else {
                CarDTO responseMapError = (CarDTO) JSON.deserialize(response.getBody(), CarDTO.class);
                responseCar.add(responseMapError);
            }
        } catch (Exception e) {
            CarDTO carDTO = new CarDTO();
            carDTO.message = 'Não foi possível encontrar nenhum veículo com o código fipe: ' + fipeCode + '. Detalhe: ' + e.getMessage();
            responseCar.add(carDTO);
        }
        return responseCar;
    }
    public class CarDTO {
        public String valor {get; set;}
        public String marca {get; set;}
        //public String modelo {get; set;}
        public Integer anoModelo {get; set;}
        //public String combustivel {get; set;}
        //public String codigoFipe {get; set;}
        public String message {get; set;}
    }
}