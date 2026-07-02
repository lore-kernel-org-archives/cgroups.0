Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EED480342
	for <cgroups@vger.kernel.org>; Thu,  2 Jul 2026 12:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782993946; cv=none; b=Vdl04P0M8QJr1Si5s3HMbH/QvECZg7qOLlCSTPuDxty/VaaHVZeA+Bp3fTNBu1jhsqYcKcu/B5wcpkHzO7/XeK96e/B9kLU0r38anoXy7ZHtMKTtmusPhvpZ70/ynwojstAu4uZHXPWAtveNkD/tM+c4T2T7gaQr1zcoBlR89Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782993946; c=relaxed/simple;
	bh=pwhC1pnqCFunGtzhXQ63RX7j7VzAQhBjFf6keqBPzvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqpXrKc/sW9ojk+lJu8/GZHZUpo3QuU7NZEQJn9CFEi+I3xTsTyAbBlUTuaQQ8Ve1/L3KxfybXzjOGSMjacDuUKGfD/nzEHq4dSybHXwDEZEEExxWIImAvvuuUGJwE3YtoX8/eIkeTU1rrEylfmYFAQKRHg92eavPINQc1BF9lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=USEhxt5W; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="USEhxt5W"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782993941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GcrsvVsst/kdgSAiAtVgg8d1SW9Rs+Vf7ZO2AYItUOA=;
	b=USEhxt5WUa1gKQ32IhAfYt/747AC6dPpgQJ4xhMW19PTcgQFu1kmYs3sIBNWZ/eoYKlY7L
	kE15jZoKkcEI4E6Io1EVoJvnMJ27IgQO5F80e4T8IFYNdZrMQBmJ5rVwXWh61/bMAlpjq8
	SM//TEe+heJQtiVaxZIZh7GSqn2nwHs=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Zhou Yingfu <yingfu.zhou@shopee.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] memcg-v1: bail out reclaim when memcg is dying
Date: Thu,  2 Jul 2026 20:02:30 +0800
Message-ID: <20260702120235.376752-5-jiayuan.chen@linux.dev>
In-Reply-To: <20260702120235.376752-1-jiayuan.chen@linux.dev>
References: <20260702120235.376752-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Jiayuan Chen <jiayuan.chen@shopee.com>

The legacy memory.limit_in_bytes and memory.memsw.limit_in_bytes writers
retry page_counter_set_max() by reclaiming synchronously in the writer
context. memory.force_empty similarly loops in synchronous reclaim until
the cgroup is empty or reclaim stops making progress.

These writes hold a kernfs active reference on the file. If cgroup removal
starts in parallel, the remover sets CSS_DYING and then waits in
kernfs_drain() under cgroup_mutex for the active reference to drain.
Continuing reclaim after the memcg is dying can therefore delay cgroup
removal and keep cgroup_mutex held for a long time.

Stop the v1 reclaim loops once the memcg is dying. For limit resizing,
keep the existing -EBUSY semantics when the new limit could not be
installed. For memory.force_empty, keep the existing best-effort success
semantics.

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/memcontrol-v1.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 765069211567..b868a58c52b8 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1513,6 +1513,10 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		if (!ret)
 			break;
 
+		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!drained) {
 			drain_all_stock(memcg);
 			drained = true;
@@ -1551,6 +1555,10 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 		if (signal_pending(current))
 			return -EINTR;
 
+		/* cgroup_rmdir() waits for us with cgroup_mutex held. */
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
 						  MEMCG_RECLAIM_MAY_SWAP, NULL))
 			nr_retries--;
-- 
2.43.0

