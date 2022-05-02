import azure.functions as func
import logging

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    responseBody = f'Received {len(req.files)} files.\n'

    for file in req.files.items(multi=True):
        filename = file[1].filename
        contents = file[1].stream.read()

        logging.info('Filename: %s' % filename)
        logging.info('Contents:')
        logging.info(contents)

        responseBody += f'Filename: {filename}\n'
        responseBody += f'Contents:\n{contents}\n'

    return func.HttpResponse(responseBody)