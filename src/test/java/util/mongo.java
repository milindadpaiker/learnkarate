package util;

import java.util.HashMap;
import java.util.Map;
import org.bson.Document;
import org.bson.conversions.Bson;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import static com.mongodb.client.model.Filters.*;

public class mongo {    
    
    public Map<String, Object> doWork(String fromJs) {
        Map<String, Object> map = new HashMap<>();
        map.put("someKey", "hello " + fromJs);
        return map;
    }

    public static String doWorkStatic(String fromJs) {
        return "hello " + fromJs;
    }   
    public String getUserRecord(String db, String coll, String email) {
        MongoClient mongoClient = new MongoClient("localhost", 27017);
        MongoDatabase  database = mongoClient.getDatabase(db);
        MongoCollection<Document> collection = database.getCollection(coll);
        Bson equalComparison = eq("email", email);        
        Document myDoc = collection.find(equalComparison).first();
        return myDoc.toJson();
    }    

}