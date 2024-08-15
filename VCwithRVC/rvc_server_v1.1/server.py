from flask import Flask, request, send_file
from scipy.io import wavfile
from VoiceConversion import getParameter, get_vc, vc_single, get_tgt_sr #inference module

infer_wav=0
app = Flask(__name__)

def inference(characterId,userAge,userGender):
    f0up_key,input_path,index_path,f0method,model_path,index_rate,filter_radius,resample_sr,rms_mix_rate,protect = getParameter(characterId,userAge,userGender)
    #get model by model path
    get_vc(model_path)
    #inference
    opt_wav=vc_single(0,input_path,f0up_key,None,f0method,index_path,index_rate,filter_radius,resample_sr,rms_mix_rate,protect)
    wavfile.write("output.wav",get_tgt_sr(),opt_wav)


@app.route('/upload', methods=['POST'])
def upload_file():
    global infer_wav
    wav = request.files['wav']
    userAge = int(request.form['age'])
    userGender = int(request.form['gender'])
    characterId = request.form['CharacterId']
    wav.save("user.wav")
    #voice conversion inference
    inference(characterId,userAge,userGender)
    return 'File uploaded successfully!'


@app.route('/download', methods=['GET'])
def download_file():#send result to client
    try:
        with open("output.wav", "rb") as infer_wav:
            return send_file('output.wav', as_attachment=True)
    except FileNotFoundError:
        print("no file exist")
        return -1

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
