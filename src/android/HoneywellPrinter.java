package honeywell.printer;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * This class echoes a string called from JavaScript.
 */
public class HoneywellPrinter extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("printImage")) {
            //String imagePath = args.getString(0);
            byte[] imagebitData = args.getString(0);
            this.printImage(imagebitData, callbackContext);
            return true;
        }
        if (action.equals("sendCommand")) {
            String[] strArray = args.getString(0);
            this.sendCommand(strArray, callbackContext);
            return true;
        }
        return false;
    }

    private void printImage(byte[] imagebitData, CallbackContext callbackContext) {
        if (imagePath != null && imagePath.length() > 0) {
            //todo 实现打印
            
            callbackContext.success("打印指令发送OK.");
        } else {
            callbackContext.error("必须传入图片本地路径.");
        }
    }

    private void sendCommand(String[] strArray, CallbackContext callbackContext) {
        if (strArray.length == 0) {
            callbackContext.error("请传入DP指令集");
        }
        for(int i=0;i<strArray.length;i++)
        {
            System.out.println(strArray[i]);
        }
        callbackContext.success("打印指令发送OK.");
    }
}
