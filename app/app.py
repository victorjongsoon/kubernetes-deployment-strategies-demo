import os
import socket
from datetime import datetime, timezone

from flask import Flask, jsonify, render_template_string


app = Flask(__name__)

APP_VERSION = os.getenv("APP_VERSION", "v1")
APP_COLOR = os.getenv("APP_COLOR", "blue")
APP_STRATEGY = os.getenv("APP_STRATEGY", "Local")
POD_NAME = os.getenv("POD_NAME") or os.getenv("HOSTNAME") or socket.gethostname()

THEMES = {
    "blue": {
        "background": "#eff6ff",
        "surface": "#ffffff",
        "accent": "#2563eb",
        "accent_dark": "#1e40af",
        "text": "#172554",
    },
    "green": {
        "background": "#ecfdf5",
        "surface": "#ffffff",
        "accent": "#16a34a",
        "accent_dark": "#166534",
        "text": "#052e16",
    },
    "orange": {
        "background": "#fff7ed",
        "surface": "#ffffff",
        "accent": "#f97316",
        "accent_dark": "#c2410c",
        "text": "#431407",
    },
}

theme = THEMES.get(APP_COLOR, THEMES["blue"])

PAGE = """
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Kubernetes Deployment Demo</title>
    <style>
      :root {
        --background: {{ theme.background }};
        --surface: {{ theme.surface }};
        --accent: {{ theme.accent }};
        --accent-dark: {{ theme.accent_dark }};
        --text: {{ theme.text }};
      }

      * {
        box-sizing: border-box;
      }

      body {
        margin: 0;
        min-height: 100vh;
        display: grid;
        place-items: center;
        background: var(--background);
        color: var(--text);
        font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      }

      main {
        width: min(920px, calc(100vw - 32px));
        padding: 40px;
        border-top: 10px solid var(--accent);
        border-radius: 8px;
        background: var(--surface);
        box-shadow: 0 24px 80px rgba(15, 23, 42, 0.14);
      }

      .eyebrow {
        margin: 0 0 12px;
        color: var(--accent-dark);
        font-size: 0.85rem;
        font-weight: 800;
        letter-spacing: 0;
        text-transform: uppercase;
      }

      h1 {
        margin: 0;
        font-size: clamp(2.5rem, 9vw, 6rem);
        line-height: 1;
      }

      .strategy {
        margin: 18px 0 32px;
        color: var(--accent-dark);
        font-size: clamp(1.25rem, 3vw, 2rem);
        font-weight: 700;
      }

      dl {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 16px;
        margin: 0;
      }

      .fact {
        min-width: 0;
        padding: 18px;
        border: 1px solid rgba(15, 23, 42, 0.12);
        border-radius: 8px;
        background: rgba(255, 255, 255, 0.7);
      }

      dt {
        margin-bottom: 8px;
        color: #475569;
        font-size: 0.8rem;
        font-weight: 700;
        letter-spacing: 0;
        text-transform: uppercase;
      }

      dd {
        margin: 0;
        overflow-wrap: anywhere;
        font-size: 1.05rem;
        font-weight: 700;
      }

      @media (max-width: 640px) {
        main {
          padding: 28px;
        }

        dl {
          grid-template-columns: 1fr;
        }
      }
    </style>
  </head>
  <body>
    <main>
      <p class="eyebrow">Kubernetes deployment strategies demo</p>
      <h1>{{ version }}</h1>
      <p class="strategy">{{ strategy }}</p>
      <dl>
        <div class="fact">
          <dt>Pod / Hostname</dt>
          <dd>{{ pod_name }}</dd>
        </div>
        <div class="fact">
          <dt>Timestamp</dt>
          <dd>{{ timestamp }}</dd>
        </div>
        <div class="fact">
          <dt>Color Theme</dt>
          <dd>{{ color }}</dd>
        </div>
        <div class="fact">
          <dt>API Endpoint</dt>
          <dd>/api/info</dd>
        </div>
      </dl>
    </main>
  </body>
</html>
"""


def now_iso():
    return datetime.now(timezone.utc).isoformat(timespec="seconds")


def app_info():
    return {
        "version": APP_VERSION,
        "strategy": APP_STRATEGY,
        "pod_name": POD_NAME,
        "timestamp": now_iso(),
    }


@app.get("/")
def index():
    info = app_info()
    return render_template_string(
        PAGE,
        color=APP_COLOR,
        pod_name=info["pod_name"],
        strategy=info["strategy"],
        theme=theme,
        timestamp=info["timestamp"],
        version=info["version"],
    )


@app.get("/healthz")
def healthz():
    return {"status": "ok"}, 200


@app.get("/api/info")
def api_info():
    return jsonify(app_info())


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
