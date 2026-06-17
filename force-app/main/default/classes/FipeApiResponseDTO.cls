public class FipeApiResponseDTO {
    public String message {get;set;}
    // public String brand {get; set;}
    // public String model {get; set;}
    // public String reference {get; set;}
    public List<AnnualValue> years {get; set;}

    public class AnnualValue {
        // public String year_id {get; set;}
        public String model_year {get; set;}
        // public String fuel {get; set;}
        public Decimal price {get; set;}
    }

    public static FipeApiResponseDTO parse(String jsonBody) {
        return (FipeApiResponseDTO) JSON.deserialize(jsonBody, FipeApiResponseDTO.class);
    }
}