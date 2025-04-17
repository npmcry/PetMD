# filepath: ./scripts/analyze_medication_data.py
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import pandas as pd
import matplotlib.pyplot as plt
import os  # Import the os module

# Set the FIREBASE_CREDENTIALS environment variable
os.environ["FIREBASE_CREDENTIALS"] = "C:\\path\\to\\your\\serviceAccountKey.json"

# Initialize Firebase Admin SDK (replace with your credentials)
# Use environment variables for credentials
cred_path = os.environ.get("FIREBASE_CREDENTIALS")
if cred_path:
    cred = credentials.Certificate(cred_path)
else:
    print("Error: FIREBASE_CREDENTIALS environment variable not set.")
    exit()

try:
    firebase_admin.initialize_app(cred)
    db = firestore.client()
except Exception as e:
    print(f"Error initializing Firebase: {e}")
    exit()


def export_medication_data():
    """Exports medication data from Firestore to a Pandas DataFrame."""
    medication_data = []
    users_ref = db.collection('users')  # Assuming you have a 'users' collection
    users = users_ref.stream()

    for user in users:
        user_dict = user.to_dict()
        pet_id = user.id  # Assuming user ID is the pet ID
        medication_logs_ref = db.collection('medication_logs').document(pet_id).collection('entries')
        medication_logs = medication_logs_ref.stream()

        for log in medication_logs:
            log_dict = log.to_dict()
            medication_data.append({
                'pet_id': pet_id,
                'medication_name': log_dict.get('medicationName'),
                'dosage': log_dict.get('dosage'),
                'timestamp': log_dict.get('timestamp')
            })

    return pd.DataFrame(medication_data)


def analyze_data(df):
    """Analyzes the medication data and generates reports."""
    if df.empty:
        print("No medication data to analyze.")
        return

    # Example: Most common medications
    medication_counts = df['medication_name'].value_counts()
    print("Most Common Medications:\n", medication_counts)

    # Example: Create a bar chart of medication usage
    medication_counts.plot(kind='bar')
    plt.title('Medication Usage')
    plt.xlabel('Medication')
    plt.ylabel('Count')
    plt.savefig('medication_usage.png')  # Save the chart to a file
    plt.show()


def main():
    """Main function to export, analyze, and report medication data."""
    df = export_medication_data()
    if not df.empty:
        analyze_data(df)
    else:
        print("No medication data found.")


if __name__ == "__main__":
    main()