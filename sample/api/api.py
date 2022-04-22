from flask import Flask
from flask_restx import Resource, Api
from flask import jsonify
import subprocess
import jc
import json


app = Flask(__name__)
api = Api(app)


# Using https://kellyjonbrazil.github.io/jc/
# https://lightkube.readthedocs.io/en/latest/


@api.route('/services')
class Services(Resource):
    def get(self):
        my_command = 'sudo bash /opt/api/bin/wrapper.sh list'
        #cmd_output = subprocess.check_output(my_command, shell=True, text=True)
        cmd_output = subprocess.check_output(my_command, shell=True, text=True)
        data = json.loads(cmd_output)
        jsonS = jsonify(data)
        return (jsonS)

@api.route('/services/nginx')
class KafkaServices(Resource):
    def get(self):
        my_command = 'sudo bash /opt/api/bin/wrapper.sh nginx'
        cmd_output = subprocess.check_output(my_command, shell=True, text=True)
        data = json.loads(cmd_output)
        jsonS = jsonify(data)
        return (jsonS)

@api.route('/services/kafka')
class SchemaRegistryService(Resource):
    def get(self):
        my_command = 'sudo bash /opt/api/bin/wrapper.sh kafka'
        cmd_output = subprocess.check_output(my_command, shell=True, text=True)
        data = json.loads(cmd_output)
        jsonS = jsonify(data)
        return (jsonS)

@api.route('/services/postgres')
class PostgresService(Resource):
    def get(self):
        my_command = 'sudo bash /opt/api/bin/wrapper.sh postgres'
        cmd_output = subprocess.check_output(my_command, shell=True, text=True)
        data = json.loads(cmd_output)
        jsonS = jsonify(data)
        return (jsonS)

@api.route('/services/mongodb')
class MongodbService(Resource):
    def get(self):
        my_command = 'sudo bash /opt/api/bin/wrapper.sh mongodb'
        cmd_output = subprocess.check_output(my_command, shell=True, text=True)
        data = json.loads(cmd_output)
        jsonS = jsonify(data)
        return (jsonS)

if __name__ == '__main__':
    app.run(debug=True)
