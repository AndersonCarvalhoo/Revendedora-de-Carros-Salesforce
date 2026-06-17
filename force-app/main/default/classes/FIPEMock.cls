@IsTest
global with sharing class FIPEMock implements HttpCalloutMock {
    final String body = '[{"valor":"R$ 80.612,00","marca":"Fiat","modelo":"ARGO DRIVE 1.0 6V Flex","anoModelo":2026,"combustivel":"Flex","codigoFipe":"001494-0","mesReferencia":"março de 2026 ","tipoVeiculo":1,"siglaCombustivel":"F","dataConsulta":"segunda-feira, 23 de março de 2026 11:29"}]';
    Integer statusCode;

    global FIPEMock(Integer statusCode) {
        this.statusCode = statusCode;
    }

    global HTTPResponse respond(HTTPRequest req) {
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        if(this.statusCode == 200) {
            res.setStatusCode(200);
            res.setBody(body);
        } else if (this.statusCode == 400) {
            res.setStatusCode(this.statusCode);
            res.setBody('{"message":"Código fipe inválido","type":"bad_request","name":"BadRequestError"}');
        } else if (this.statusCode == 500) {
            CalloutException e = (CalloutException)CalloutException.class.newInstance();
            e.setMessage('Timeout simulado pelo Mock');
            throw e;
        }

        return res;
    }
}