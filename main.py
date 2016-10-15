#!/bin/python

from datetime import date
import tornado.escape
import tornado.httpserver
import tornado.ioloop
import tornado.web
from tornado.options import define, options
import MySQLdb
import torndb
import json
import base64

define("myoption", default="In python", help="Option is work value") 
define("mysql_host", default="127.0.0.1:3306", help="Main DB")
define("mysql_user", default="user", help="DB user ID")
define("mysql_password", default="password", help="DB user PassWord")
define("mysql_database", default="database", help="DB schema name")
define("admin_pass", default="test", help="DB schema name")

class NoneTouchRowError(Exception):
    def __str__(self):
        return "Any Database Rows touch by query"

class Application(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/getgamebyid/([0-9]+)", GetGameByIdHandler),
            (r"/version", VersionHandler),
            (r"/mines", GetMinesHandler_all),
            (r"/mines/([+-]?[0-9]+(?:[.]?[0-9]*))/([+-]?[0-9]+(?:[.]?[0-9]*))", MinesHandler),
            (r"/mines/([+-]?[0-9]+(?:[.]?[0-9]*))/([+-]?[0-9]+(?:[.]?[0-9]*))/(.*)", MinesHandler),
            (r"/mines/([0-9]+)/(.*)", MinesHandler),
        ]
        settings = dict(debug=False,)
        super(Application, self).__init__(handlers, **settings)
        # Have one global connection to the blog DB across all handlers
        self.db = torndb.Connection(
            host=options.mysql_host, database=options.mysql_database,
            user=options.mysql_user, password=options.mysql_password)

class BaseHandler(tornado.web.RequestHandler):
    @property
    def db(self):
        return self.application.db

class VersionHandler(BaseHandler):
    def get(self):
        response = { 'version': '0.0.1',
                     'last_build':  date.today().isoformat(),
                     'server configure': options.myoption}
        self.write(response)
 
class GetGameByIdHandler(BaseHandler):
    def get(self, id):
        response = { 'id': int(id),
                     'name': 'Crazy Game',
                     'release_date': date.today().isoformat() }
        self.write(response)

class GetMinesHandler_all(BaseHandler):
    def get(self):
        self.write(json.dumps(self.db.query("select * from mine;")))   
 
class MinesHandler(BaseHandler):
    def get(self, lat, lon):
        print str(float(lat))
        print str(float(lon))
        self.write(json.dumps(self.db.query("call rec_geo(%s, %s, 1000);",
            str(float(lat)), str(float(lon)))))
    def post(self, lat, lon, user):
        print lat, lon, user 
        try:
            user = self.db.get("select iduser from user where id = %s", user)["iduser"]
            print user
            tmp = self.db.insert("insert into mine (lat, lon, user) values (%s, %s, %s)",
                str(float(lat)), str(float(lon)), str(int(user)))
            print tmp
            self.write({"state":"OK", "id":tmp})
        except:
            self.write({"state":"FAIL"})
    def delete(self, idmine, user):
        print idmine, user
        try:
            user = self.db.get("select iduser from user where id = %s", user)["iduser"]
            if user is not None:
                tmp = self.db.update("delete from mine where idmine = %s", str(int(idmine)))
            if tmp >= 1:
                self.write({"state":"OK"})
            else :
                raise NoneTouchRowError
        except Exception as e:
            print e
            self.write({"state":"FAIL"})

    def put(self, idmine, demage, user):
        print idmine, demage, user
        try:
            idmine = int(idmine)
            demage = int(demage)
            user = self.db.get("select iduser from user where id = %s", user)["iduser"]
            if user is not None:
                tmp = self.db.update("update mine set HP = HP - %s where idmine = %s",str(demage) ,str(int(idmine)))
            if tmp >= 1:
                self.write({"state":"OK"})
            else :
                raise NoneTouchRowError
        except Exception as e:
            print e
            self.write({"state":"FAIL"})

if __name__ == "__main__":
    tornado.options.parse_config_file("server.conf")
    #application.listen(8888)
    http_server = tornado.httpserver.HTTPServer(Application())
    http_server.bind(8888)
    http_server.start(8)    
    #IOLoop.current().start()
    #tornado.ioloop.IOLoop.instance().start()
    tornado.ioloop.IOLoop.current().start()

