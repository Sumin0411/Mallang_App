import requests

id = '토끼'
characterid = 'sombra'
# url = 'http://124.62.22.104:5002'
url = 'http://127.0.0.1:5000'

def upload_file():
    files = {'wav': open(f'user/{id}/{id}.wav', 'rb')}
    data = {'CharacterId': characterid, 
            'gender': 0, 
            'age': 28}
    response = requests.post(f'{url}/upload', files=files, data=data)
    print(response.text)

def download_file():
    response = requests.get(f'{url}/download')
    with open(f'result/{id}To{characterid}.wav', 'wb') as file:
        file.write(response.content)
        
    print('File downloaded successfully!')

if __name__ == '__main__':
    upload_file()
    download_file()