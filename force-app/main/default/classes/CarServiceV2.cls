public with sharing class CarServiceV2 {

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
                Decimal fipeValue = FIPERequestV2.getCarPriceByFipe(req.fipeCode, req.modelYear);
                carResponse.isSuccess = true;
                carResponse.fipeReferencePrice = fipeValue;
            } catch (Exception e) {
                carResponse.isSuccess = false;
                carResponse.errorMessage = e.getMessage();
            }
            
            carResponseList.add(carResponse);
        }
        return carResponseList;
    }
}