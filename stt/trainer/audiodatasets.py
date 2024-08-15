from datasets import Dataset, DatasetDict
from datasets import Audio
import json

class AudioDatasets:
    def __init__(self, data_path, push_to_hub=False):
        # open json file
        self.dataset_path = data_path
        self.ds = Dataset.from_dict({"audio": [path for path in data_path["path"]],
                                     "transcripts": [transcript for transcript in data_path["sentence"]]}).cast_column("audio", Audio(sampling_rate=16000))
        self.dataset = self.split(push_to_hub=push_to_hub)

    def split(self, test_size=0.2, push_to_hub=False):
        train_testvalid = self.ds.train_test_split(test_size=test_size)
        test_valid = train_testvalid["test"].train_test_split(test_size=0.5)
        datasets = DatasetDict({
            "train": train_testvalid["train"],
            "test": test_valid["test"],
            "valid": test_valid["train"]})
        if push_to_hub:
            datasets.push_to_hub("업로드할 허깅페이스 주소 입력")
        return datasets
    
