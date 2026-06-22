from flask import Flask, jsonify, request

app = Flask(__name__)

users = []


@app.route("/")
def home():
    return jsonify({
        "message": "DevOps Portfolio API",
        "status": "running"
    })


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy"
    })


@app.route("/users", methods=["GET"])
def get_users():
    return jsonify(users)


@app.route("/users", methods=["POST"])
def create_user():
    data = request.json

    user = {
        "id": len(users) + 1,
        "name": data.get("name"),
        "email": data.get("email")
    }

    users.append(user)
    print("Created User")

    return jsonify(user), 201


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
