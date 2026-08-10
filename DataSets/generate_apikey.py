import secrets
import psycopg2
from dotenv import load_dotenv
import os

load_dotenv()

def generate_secure_api_key() -> str:
    # SUB-header + random string
    return "SUB-" + secrets.token_urlsafe(36)


def create_subscriber_api_key(customer_name: str, customer_email: str, expires_at: str | None):
    conn = psycopg2.connect(
        host=os.getenv("DB_HOST"),
        port=os.getenv("DB_PORT"),
        dbname=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD")
    )
    cur = conn.cursor()
    new_key = generate_secure_api_key()

    cur.execute("""
        INSERT INTO subscriber_api_keys (api_key, customer_name, customer_email, expires_at)
        VALUES (%s, %s, %s, %s)
        RETURNING api_key;
    """, (new_key, customer_name, customer_email, expires_at))

    result_key = cur.fetchone()[0]
    conn.commit()
    cur.close()
    conn.close()

    print("=" * 60)
    print(f"✅ New API Key Created: {result_key}")
    print("=" * 60)
    print("Deliver this secret to client securely.")
    return result_key


if __name__ == "__main__":
    # ========== 修改这里填入客户信息 ==========
    create_subscriber_api_key(
        customer_name="Demo Client",
        customer_email="client@example.com",
        expires_at="2027-07-28"   # ISO日期，None代表永不过期
        # expires_at = None
    )