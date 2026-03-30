from datetime import datetime
from typing import Any

from pydantic import BaseModel


class Task(BaseModel):
    id: int
    jira_key: str
    status: str
    repo: str | None = None
    branch: str | None = None
    pr_number: int | None = None
    pr_url: str | None = None
    title: str | None = None
    summary: str | None = None
    created_at: datetime
    last_addressed: datetime
    paused_reason: str | None = None
    metadata: dict[str, Any] = {}


class Memory(BaseModel):
    id: int
    category: str
    repo: str | None = None
    jira_key: str | None = None
    title: str
    content: str
    tags: list[str] = []
    created_at: datetime
    metadata: dict[str, Any] = {}


class MemorySearchResult(Memory):
    similarity: float
