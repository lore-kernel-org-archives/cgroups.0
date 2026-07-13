Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA363E2AC9
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 09:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783935497; cv=none; b=oQ/L8qn4E5UKO1OacC3DfN/6tCca4ofhfm0KgMl1RsPiywriUoc1GHxhyYmu9ErNchmriW+ibZeDRcSVzQE3jcbJ1m65R6SeOSngHcxfccZEy//ccm6o+0IA5ZX8t+smbSuN8FZSjeJ6q4qFgBA7+lvhLkLpoaQcnu/cepaHzM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783935497; c=relaxed/simple;
	bh=WyCQypFRFdFymrXZwQWMUqNFTWvD+Fc31glBT9ORvPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jxVCoTCZ1FffyvagIT3publBX19NbuP6MrUGZqW0aERRy06jv5JLUaoKifg9fqQ27JXmdXdYNWHX8vLLb6XVh9uk0i9NF/S68EnuET2xDKpY0iUUoNztQJy3oJVNJ+iQcbkwy3EcOuLw9sNusyJsmwVwLkXJ+1NwcNap1lZawjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=JIDk3tx6; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="JIDk3tx6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783935477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rvVsmNUiaRCk48qdsU4ef5SiZPZfdpdcGy8a4cIbIvw=;
	b=JIDk3tx6AB3lAyGSfAFF9Get8nRGjzzD8GOI/dTjvMuDc1MEDecxUAeE8KNeNO9wCUw3wq
	V/H3MTaTZxqBmhIhrSplO6cWnP+gdEV5EGQro5wriG9oC1W+cqGKExJDQ3v7fTfSDQdKcj
	MsJU4thh9KxUPUoR6VkiPCKeuvZGEhc=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void
Date: Mon, 13 Jul 2026 17:37:37 +0800
Message-ID: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

Commit 7d74b06f240f ("memcg: use for_each_mem_cgroup") replaced the
mem_cgroup_walk_tree() call in mem_cgroup_oom_notify() with
for_each_mem_cgroup_tree(), but left mem_cgroup_oom_notify_cb() with the
int return type required by the old callback interface.

The function now has a single direct caller and no failure path. Make it
return void.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol-v1.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index e8b6e1560278..73bea1b5c8dd 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -752,7 +752,7 @@ static int compare_thresholds(const void *a, const void *b)
 	return 0;
 }
 
-static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
+static void mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup_eventfd_list *ev;
 
@@ -762,7 +762,6 @@ static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
 		eventfd_signal(ev->eventfd);
 
 	spin_unlock(&memcg_oom_lock);
-	return 0;
 }
 
 static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
-- 
2.43.0

