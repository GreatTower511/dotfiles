#!/usr/bin/env python3
"""Stop フック: 返答が英語になっていたら止めて、日本語で書き直させる。

操作者の方針（2026-11-27）: 返答は常に日本語。メモリ（always-reply-in-japanese）に書いても、
英語の検索結果や担当の報告を受けた直後に英語へ崩れるので、機械的に止める。

判定:
  - 今のターン（最後の利用者の入力より後）の、assistant の文の塊を 1 つずつ見る
  - コードブロック・インラインコード・URL・パスを除いてから、かな漢字の数 J と英字の数 L を数える
  - L が MIN_LATIN 以上で、J / (J + L) が RATIO 未満の塊があれば英語とみなす
    （2026-11-27 に過去の返答で合わせた: 英語の返答は 0.21 以下、日本語の返答は 0.36 以上だった）
止めるときは decision=block と理由を返す。stop_hook_active が true のとき（止めた後の書き直し）は通す
（無限に止めないため）。読めない入力・判定できない場合は通す（exit 0）。
"""

import json
import re
import sys

MIN_LATIN = 30
RATIO = 0.3

FENCE = re.compile(r"```.*?(```|$)", re.S)
INLINE_CODE = re.compile(r"`[^`\n]*`")
MD_LINK_TARGET = re.compile(r"\]\([^)]*\)")
URL = re.compile(r"https?://\S+")
PATH = re.compile(r"(?:~|\.{0,2})?/[\w.\-/@%+]+")
JA = re.compile(r"[぀-ヿ㐀-鿿ｦ-ﾟ]")
LATIN = re.compile(r"[A-Za-z]")


def strip_noise(text: str) -> str:
    for pattern in (FENCE, INLINE_CODE, MD_LINK_TARGET, URL, PATH):
        text = pattern.sub(" ", text)
    return text


def is_english(text: str) -> bool:
    body = strip_noise(text)
    ja = len(JA.findall(body))
    latin = len(LATIN.findall(body))
    if latin < MIN_LATIN:
        return False
    return ja / (ja + latin) < RATIO


def is_user_prompt(entry: dict) -> bool:
    """利用者の入力か（ツールの結果は type=user でも数えない）。"""
    if entry.get("type") != "user" or entry.get("isSidechain"):
        return False
    content = (entry.get("message") or {}).get("content")
    if isinstance(content, str):
        return True
    if isinstance(content, list):
        return any(isinstance(b, dict) and b.get("type") == "text" for b in content)
    return False


def turn_texts(transcript_path: str) -> list[str]:
    entries = []
    with open(transcript_path, encoding="utf-8") as f:
        for line in f:
            try:
                entries.append(json.loads(line))
            except ValueError:
                continue
    texts: list[str] = []
    for entry in reversed(entries):
        if is_user_prompt(entry):
            break
        if entry.get("type") != "assistant" or entry.get("isSidechain"):
            continue
        for block in (entry.get("message") or {}).get("content") or []:
            if isinstance(block, dict) and block.get("type") == "text":
                texts.append(block.get("text") or "")
    return texts


def main() -> int:
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        return 0
    if payload.get("stop_hook_active"):
        return 0
    texts: list[str] = []
    last = payload.get("last_assistant_message")
    if isinstance(last, str) and last:
        texts.append(last)
    path = payload.get("transcript_path")
    if path:
        try:
            texts.extend(turn_texts(path))
        except OSError:
            pass
    if any(is_english(t) for t in texts):
        print(
            json.dumps(
                {
                    "decision": "block",
                    "reason": "[日本語チェック] このターンの返答に英語の文があります。"
                    "操作者の方針で返答は常に日本語です。同じ内容を日本語で書き直してください"
                    "（コード・コマンド・識別子はそのままでよい）。",
                },
                ensure_ascii=False,
            )
        )
    return 0


if __name__ == "__main__":
    sys.exit(main())
