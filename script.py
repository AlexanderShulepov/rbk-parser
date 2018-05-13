from api import api
from parser import parser
import time
parser=parser()
api=api()
def parse_range(start_id,increments):
	for id in range(start_id,start_id+increments):
		data=parser.parse(id)
		responce=api.put(id,float(data['money']['amount']), data['money']['currency'], data['company'], data['store_page'])
		print(responce)
		time.sleep(10)

def get(id):
	print(api.get(id))


parse_range(1222609871,10)
#Варианты ответов
#{'ERROR': 'Transfer already exists', 'status': 403}
#{'ERROR': 'Transfer already exists', 'status': 403}
#{'status': 201, 'invoke_id': 1222609873}
get(1222609871)
#Варианты ответов
#{'amount': 1000, 'currency': 'RUB', 'company': 'NN', 'invoke_id': 123, 'store_page': 'example.com', 'status': 200}
#'ERROR': 'Transfer not found', 'status': 404}
