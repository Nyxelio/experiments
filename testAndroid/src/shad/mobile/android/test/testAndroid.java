package shad.mobile.android.test;

import android.app.*;
import android.os.Bundle;
import android.view.*;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.view.View.OnClickListener;

public class testAndroid extends Activity {
    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //setContentView(R.layout.main);
        setContentView(R.layout.menu);
    }

public boolean onCreateOptionsMenu(Menu menu) {
	MenuInflater inflater = getMenuInflater();
	inflater.inflate(R.menu.options_menu, menu);
	return true;
	}

public boolean onOptionsItemSelected(MenuItem item) {
	switch (item.getItemId()) {
	case R.id.itemEtatReseau:
	int i = 1;
	this.setContentView(R.layout.etatreseau);
	return true;
	}
	
	return false;
	}
}