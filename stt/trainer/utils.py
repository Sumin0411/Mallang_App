import json
import glob
import pandas as pd

def make_df(data_path):

    data_file = data_path + "*.json"
    json_files = glob.glob(data_file)

    df_list = []
    for file in json_files:
        # 각 파일을 json으로 읽어 들입니다.
        with open(file, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        # 'sentence'와 'audio'의 'path'를 추출하여 데이터프레임으로 만들고, 이를 리스트에 저장합니다.
        df = pd.DataFrame({'sentence': [data['sentence']], 'path': [data_path + data['audio']['path']]})
        df_list.append(df)

    # 모든 데이터프레임을 하나로 합칩니다.
    merged_df = pd.concat(df_list, ignore_index=True)
    return merged_df
    


# data_path = "C:\\flyai\\mallang\\stt\\trainer\\data\\"

# data = make_df(data_path)
# print(data)