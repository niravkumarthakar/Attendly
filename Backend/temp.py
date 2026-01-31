import os
import sys
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def test_connection():
    # 1. Check if URL exists
    database_url = os.getenv('DATABASE_URL')
    if not database_url:
        print("❌ Error: DATABASE_URL not found in environment or .env file.")
        return

    # Mask password for display
    safe_url = database_url.split('@')[-1] if '@' in database_url else "..."
    print(f"🔌 Attempting to connect to: ...@{safe_url}")

    try:
        # 2. Create Engine
        engine = create_engine(database_url)
        
        # 3. Try to Connect and Run Query
        with engine.connect() as connection:
            # Check version (confirms DB is alive)
            result = connection.execute(text("SELECT version();"))
            version = result.scalar()
            
            # Check timeout setting (relevant to your error)
            timeout = connection.execute(text("SHOW statement_timeout;")).scalar()
            
            print("\n✅ DATABASE IS WORKING!")
            print("=" * 40)
            print(f"📊 Version: {version}")
            print(f"⏱️  Timeout Setting: {timeout}")
            print("=" * 40)

    except Exception as e:
        print("\n❌ DATABASE CONNECTION FAILED")
        print("=" * 40)
        print(f"Error Type: {type(e).__name__}")
        print(f"Details: {e}")
        print("=" * 40)
        print("\nTroubleshooting tips:")
        print("1. Check if Postgres server is running (Task Manager/Services)")
        print("2. Verify username/password in .env")
        print("3. Check if firewall is blocking port 5432")

if __name__ == "__main__":
    test_connection()
