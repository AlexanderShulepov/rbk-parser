import requests
from fake_useragent import UserAgent
from bs4 import BeautifulSoup
import re
class parser:
	def __init__(self):
		self.PATH='https://sko.rbkmoney.ru/opencms/opencms/default/success.html?invoiceId='

	def get_page(self,id):
		self.URL=self.PATH+str(id)
		response = requests.get(self.URL)
		html = response.content
		self.soup = BeautifulSoup(html,'html.parser')
	
	def find_class(self,t,c):
		return self.soup.find(lambda tag: tag.name == t and tag.get('class') == [c])

	def parse_money(self):
		money = self.find_class('div','g-p').text.replace('\t','').replace('\n','').split(' ')[1:]
		return {"currency":money[1],"amount":money[0]}

	def parse_company(self):
		return self.find_class('div','s-u').text
	def parse_ref(self):
		return self.find_class('div','nav').a.get('href')
	def parse(self,id):
		self.get_page(id)
		return {
			'company':self.parse_company(),
			'money':self.parse_money(),
			'store_page':self.parse_ref()
		}


