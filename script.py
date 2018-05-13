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
get(1222609871)


	
