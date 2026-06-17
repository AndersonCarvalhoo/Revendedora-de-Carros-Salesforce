public with sharing class CarService {

    public class CarRequest {
        @InvocableVariable(required = true) public String fipeCode;
        @InvocableVariable(required = true) public String modelYear;
    }
    public class CarResponse {
        @InvocableVariable public Decimal fipeReferencePrice;
        @InvocableVariable public Boolean isSuccess;
        @InvocableVariable public String errorMessage;
    }

    @InvocableMethod(callout=true label='Label' description='Description' category='Category')
    public static List<CarResponse> getCarDetails(List<CarRequest> carRequests) {
        List<CarResponse> carResponseList = new List<CarResponse>();

        for(CarRequest req : carRequests) {
            CarResponse carResponse = new CarResponse();
            
            try {
                List<FIPERequest.CarDTO> carsDetails = FIPERequest.getCarPriceByFipe(req.fipeCode);

                for(FIPERequest.CarDTO carDetails : carsDetails) {
                    if(carDetails.message != null) {
                        carResponse.isSuccess = false;
                        carResponse.errorMessage = carDetails.message;
                        break;
                    }

                    if(carDetails.anoModelo != null && String.valueOf(carDetails.anoModelo).contains(req.modelYear)) {
                        carResponse.fipeReferencePrice = parseCurrency(carDetails.valor);
                        carResponse.isSuccess = true;
                        break;
                    }
                }
            } catch(Exception e) {
                carResponse.isSuccess = false;
                carResponse.errorMessage = e.getMessage();
            }

            carResponseList.add(carResponse);
        }
        return carResponseList;
    }

    private static Decimal parseCurrency(String val) {
        if (String.isBlank(val)) return 0.0;
        
        String cleaned = val.replace('R$', '').replace('.', '').trim();
        cleaned = cleaned.replace(',', '.');
        
        try {
            return Decimal.valueOf(cleaned);
        } catch (Exception e) {
            System.debug('Erro ao converter valor FIPE: ' + val);
            return 0.0;
        }
    }
}