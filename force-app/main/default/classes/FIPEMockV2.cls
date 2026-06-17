@IsTest
global with sharing class FIPEMockV2 implements HttpCalloutMock {
    final String body = '{"brand":"Fiat","model":"ARGO DRIVE 1.0 6V Flex","reference":"maio de 2026","years":[{"year_id":"32000-5","model_year":"Zero Km","fuel":"Flex","price":91651},{"year_id":"2026-5","model_year":"2026","fuel":"Flex","price":81249},{"year_id":"2025-5","model_year":"2025","fuel":"Flex","price":71950},{"year_id":"2024-5","model_year":"2024","fuel":"Flex","price":68498},{"year_id":"2023-5","model_year":"2023","fuel":"Flex","price":64827},{"year_id":"2022-5","model_year":"2022","fuel":"Flex","price":60082},{"year_id":"2021-5","model_year":"2021","fuel":"Flex","price":55822},{"year_id":"2020-5","model_year":"2020","fuel":"Flex","price":52808},{"year_id":"2019-5","model_year":"2019","fuel":"Flex","price":50701},{"year_id":"2018-5","model_year":"2018","fuel":"Flex","price":48826}]}';
    Integer statusCode;

    global FIPEMockV2(Integer statusCode) {
        this.statusCode = statusCode;
    }

    global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        if(this.statusCode == 200) {
            res.setStatusCode(200);
            res.setBody(body);
        } else if (this.statusCode == 422) {
            res.setStatusCode(this.statusCode);
            res.setBody('{ "message": "O campo fipe_code não contém um valor válido." }');
        } else if (this.statusCode == 500) {
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage('Timeout simulado pelo Mock');
            throw e;
        }

        return res;
    }
}