import postgresql
import json
class api:
	def __init__(self):
		self.connector = postgresql.open('pq://postgres:842839@localhost:5432/test')
	
	def query(self, query):	#postgresq query
		return self.connector.query("select * from "+ query)

	def put(self,invoke , amount ,currency ,company ,store_page ):
		return json.loads(self.query("add_transfer({0},{1},'{2}','{3}','{4}')".format(invoke,amount,currency,company,store_page))[0][0])
	
	def get(self,id):
		return json.loads(self.query("get_transfer({0})".format(id))[0][0])
