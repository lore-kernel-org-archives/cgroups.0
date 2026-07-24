Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE1524A05D
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 02:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784859497; cv=none; b=QX8EaqiSA7MXK4XQKvo8dQLUWoYUBtIVRZTE9pQ3l5BuXsX45V+qezMPfu8Xbj+VR8fWOsPMnNZboXaJB1xJuIwVUTMpbDZKaqz3yB2S1zGwWu5r2jDP9PRS5e9e1TK98blp1HFPzY3MzjjManZcpvJKVU/thwvmJE059NhRXJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784859497; c=relaxed/simple;
	bh=T1lioKmUtb8VUim2b8a2stXptMGrLsI4eICPczJnwTE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=P2p0uTmKY+Ght09578RbNLBOZohhhCftS7G2b4rX9Mm/5fcPhldrpq8+R0oa82X32Twe8gMQqcUvkMW3f0M2vwHXA7xD0Sl/AG1YYMMMWMfwYI+JvvJ/fWSrmWLR04zCDnW4QM+z9QyjwcHnDoxJlLLop4ejjZOglQH9hUvhtco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m6LyyPZe; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m6LyyPZe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784859482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dkDxI/YU4h74RWLt0j/KtkqxL8bNC1CurQ3sW+7Nc40=;
	b=m6LyyPZeNG8i5rjVFkZXPlsO0v9FnA42zs3OT99CGDpyOYelE39pPRuFwb2gnhWuxVFMi5
	fWw090Je9B4PLWam00PonOTRKdW/2S9MztGP9S/nourLMlqjLDNLuCKWh+CnH9S1UymNES
	SQMQVCqlWejoODsnz7GdinNbRZ0xZls=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <guopeng.zhang@linux.dev>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
Date: Fri, 24 Jul 2026 10:18:05 +0800
Message-Id: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

kernfs serializes file operations only per open file, so separate open
files can update the same memory.high or memory.max file concurrently.
Both handlers store the new limit before synchronous reclaim, but
continue to use the writer's local target in the reclaim loop. If another
writer raises or removes the limit, the first writer can continue
reclaiming toward a stale target.

For memory.max, this can leave the writer looping indefinitely once
reclaim retries are exhausted. The OOM path sees sufficient margin under
the current limit and returns true without killing, while the writer
still compares usage against its stale target and records another OOM
event.

Check the current limit at the start of each reclaim iteration and stop
if it no longer matches the writer's target.

Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
Reproducer:

Populate a cgroup with anonymous memory and disable swapping. Lower
memory.max from one open file, then restore it to "max" through another
open file after the new limit becomes visible.

Without the patch, the first writer remains blocked and repeatedly
increments the OOM event counter. With the patch, it returns normally.

 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23..638bdc766616 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4798,6 +4798,9 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
 
+		if (high != READ_ONCE(memcg->memory.high))
+			break;
+
 		if (nr_pages <= high)
 			break;
 
@@ -4853,6 +4856,9 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 
+		if (max != READ_ONCE(memcg->memory.max))
+			break;
+
 		if (nr_pages <= max)
 			break;
 
-- 
2.25.1
