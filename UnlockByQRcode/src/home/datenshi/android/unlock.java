package home.datenshi.android;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class unlock extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        
        // Affiche l'écran d'accueil
        TextView textView = (TextView) findViewById(R.id.TextView);
        textView.setText(getResources().getString(R.string.Accueil));
    
    Button boutonGenerer = (Button) findViewById(R.id.ButtonGenerer);
    boutonGenerer.setOnClickListener(mboutonGenerer);
    }
    
    public final Button.OnClickListener mboutonGenerer = new Button.OnClickListener () {
    	public void onClick(View v) {
    		try{
    				// Affiche l'écran d'accueil
    				TextView textView = (TextView) findViewById(R.id.TextView);
    				textView.setText("le bouton a été appuyé");
    				
    				encodeBarcode("TEXT_TYPE", "http://n.procureur.free.fr");

     
    			} catch (Exception e) {}
    	}
    	};
 
    	private void encodeBarcode(String type, String data) {
    	    Intent intent = new Intent("com.google.zxing.client.android.ENCODE");
    	    intent.putExtra("ENCODE_TYPE", type);
    	    intent.putExtra("ENCODE_DATA", data);
    	    startActivity(intent);
    	  }
}
